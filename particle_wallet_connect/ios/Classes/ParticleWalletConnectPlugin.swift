//
//  ParticleWalletConnectPlugin.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

import Alamofire
import Flutter
import Foundation
import ParticleWalletConnect
import SwiftyJSON
import WalletConnectSwift

public class ParticleWalletConnectPlugin: NSObject, FlutterPlugin {
    var eventChannel: FlutterEventChannel?
    var events: FlutterEventSink?
    
    var requestCallbacks: [String: (WCResult<Data?>) -> Void] = [:]
    var shouldStartCallbacks: [String: (String, Int) -> Void] = [:]
    
    override public init() {
        super.init()
    }

    public enum Method: String {
        case initialize
        case setCustomRpcUrl
        case connect
        case disconnect
        case updateSession
        case removeSession
        case getSession
        case getAllSessions
        case startSession
        case handleRequest
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "wallet_connect_bridge", binaryMessenger: registrar.messenger())
        
        let instance = ParticleWalletConnectPlugin()
        
        instance.eventChannel = FlutterEventChannel(name: "wallet_connect_bridge.event", binaryMessenger: registrar.messenger())
        instance.eventChannel?.setStreamHandler(instance)

        channel.setMethodCallHandler(instance.handle(_:result:))
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
   
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = ParticleWalletConnectPlugin.Method(rawValue: call.method) else {
            result(FlutterMethodNotImplemented)
            return
        }
        
        let json = call.arguments
        
        switch method {
        case .initialize:
            self.initialize(json as? String)
        case .setCustomRpcUrl:
            self.setCustomRpcUrl(json as? String)
        case .connect:
            self.connect(json as? String, flutterResult: result)
        case .disconnect:
            self.disconnect(json as? String)
        case .updateSession:
            self.updateSession(json as? String)
        case .removeSession:
            self.removeSession(json as? String)
        case .getSession:
            self.getSession(json as? String, flutterResult: result)
        case .getAllSessions:
            self.getAllSessions(flutterResult: result)
        case .startSession:
            self.startSession(json as? String)
        case .handleRequest:
            self.handleRequest(json as? String)
        }
    }
}

// MARK: -  Methods

public extension ParticleWalletConnectPlugin {
    func initialize(_ json: String?) {
        guard let json = json else {
            return
        }
        
        let data = JSON(parseJSON: json)
        let name = data["name"].stringValue.lowercased()
        let iconStr = data["icon"].stringValue.lowercased()
        let urlStr = data["url"].stringValue.lowercased()
        let description = data["description"].string
        guard let icon = URL(string: iconStr) else {
            return print("initialize error, \(iconStr) is not a valid url")
        }

        guard let url = URL(string: urlStr) else {
            return print("initialize error, \(urlStr) is not a valid url")
        }

        ParticleWalletConnect.initialize(WalletMetaData(name: name, icon: icon, url: url, description: description))
        ParticleWalletConnect.shared.delegate = self
    }
    
    func setCustomRpcUrl(_ json: String?) {
        guard let rpcUrl = json else {
            return
        }
        
        ParticleWalletConnect.shared.setRpcUrl(rpcUrl)
    }
    
    func connect(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let code = json else {
            return
        }
        ParticleWalletConnect.shared.connect(code: code)
    }
    
    func disconnect(_ json: String?) {
        guard let topic = json else {
            return
        }
        guard let session = ParticleWalletConnect.shared.getSession(by: topic) else {
            return
        }
        ParticleWalletConnect.shared.disconnect(session: session)
    }
    
    func updateSession(_ json: String?) {
        guard let json = json else {
            return
        }
        
        let data = JSON(parseJSON: json)
        let topic = data["topic"].stringValue
        guard let session = ParticleWalletConnect.shared.getSession(by: topic) else {
            return
        }
        let publicAddress = data["public_address"].stringValue
        let chainId = data["chain_id"].intValue
        
        ParticleWalletConnect.shared.updateSession(session, publicAddress: publicAddress, chainId: chainId)
    }
    
    func removeSession(_ json: String?) {
        guard let topic = json else {
            return
        }
        ParticleWalletConnect.shared.removeSession(by: topic)
    }
    
    func getSession(_ json: String?, flutterResult: FlutterResult) {
        guard let topic = json else {
            return
        }
        guard let session = ParticleWalletConnect.shared.getSession(by: topic) else { return }
        
        let dappMetaData = self.getDapp(from: session)
        let data = try! JSONEncoder().encode(dappMetaData)
        guard let json = String(data: data, encoding: .utf8) else { return }
        flutterResult(json)
    }
    
    func getAllSessions(flutterResult: FlutterResult) {
        let sessions = ParticleWalletConnect.shared.getAllSessions()
        let dappMetaDatas = sessions.map {
            getDapp(from: $0)
        }
        
        let data = try! JSONEncoder().encode(dappMetaDatas)
        guard let json = String(data: data, encoding: .utf8) else { return }
        flutterResult(json)
    }
    
    func startSession(_ json: String?) {
        guard let json = json else {
            return
        }
        let data = JSON(parseJSON: json)
        let topic = data["topic"].stringValue
        let publicAddress = data["public_address"].stringValue
        let chainId = data["chain_id"].intValue
        if self.shouldStartCallbacks.keys.contains(topic) {
            let shouldStartCallback = self.shouldStartCallbacks[topic]
            shouldStartCallback?(publicAddress, chainId)
            self.shouldStartCallbacks.removeValue(forKey: topic)
        }
    }
    
    func handleRequest(_ json: String?) {
        guard let json = json else {
            return
        }
        let data = JSON(parseJSON: json)
        let requestId = data["request_id"].stringValue
        let isSuccess = data["is_success"].boolValue
        if isSuccess {
            //
            let result = data["data"]
            if self.requestCallbacks.keys.contains(requestId) {
                let requestCallback = self.requestCallbacks[requestId]
                let encoded = try? JSONEncoder().encode(result)
                requestCallback?(.success(encoded))
                self.requestCallbacks.removeValue(forKey: requestId)
            }
        } else {
            // error
            let code = data["data"]["code"].int
            let message = data["data"]["message"].string
            let errorData = data["data"]["data"].string
            let error = WCResponseError(code: code, message: message, data: errorData)
            if self.requestCallbacks.keys.contains(requestId) {
                let requestCallback = self.requestCallbacks[requestId]
                requestCallback?(.failure(error))
                self.requestCallbacks.removeValue(forKey: requestId)
            }
        }
    }
    
    private func getDapp(from session: WalletConnectSwift.Session) -> DappMetaData {
        return DappMetaData(topic: session.url.topic, name: session.dAppInfo.peerMeta.name, icon: session.dAppInfo.peerMeta.icons.first?.absoluteString ?? "", url: session.dAppInfo.peerMeta.url.absoluteString)
    }
}

extension ParticleWalletConnectPlugin: ParticleWalletConnectDelegate {
    public func request(topic: String, method: String, params: [Encodable], completion: @escaping (WCResult<Data?>) -> Void) {
        let requestId = UUID().uuidString
        
        let values = params.map { para -> ValueType in
            let p = convertData(para: para)

            let data = try! JSONEncoder().encode(p)
            return try! JSONDecoder().decode(ValueType.self, from: data)
        }
        let requestData = RequestData(request_id: requestId, method: method, params: values)
        self.requestCallbacks[requestId] = completion
        
        let eventData = EventData(eventMethod: "request", data: requestData)
        let data = try! JSONEncoder().encode(eventData)
        guard let json = String(data: data, encoding: .utf8) else { return }
        if self.events != nil {
            self.events!(json)
        }
    }
    
    public func didConnectSession(_ session: WalletConnectSwift.Session) {
        let dappMetaData = self.getDapp(from: session)
        let eventData = EventData(eventMethod: "didConnect", data: dappMetaData)
        let data = try! JSONEncoder().encode(eventData)
        guard let json = String(data: data, encoding: .utf8) else { return }
        if self.events != nil {
            self.events!(json)
        }
    }
    
    public func didDisconnect(_ session: WalletConnectSwift.Session) {
        let dappMetaData = self.getDapp(from: session)
        let eventData = EventData(eventMethod: "didDisconnect", data: dappMetaData)
        let data = try! JSONEncoder().encode(eventData)
        guard let json = String(data: data, encoding: .utf8) else { return }
        if self.events != nil {
            self.events!(json)
        }
    }
    
    public func shouldStartSession(_ session: WalletConnectSwift.Session, completion: @escaping (String, Int) -> Void) {
        let dappMetaData = self.getDapp(from: session)
        self.shouldStartCallbacks[session.url.topic] = completion
        
        let eventData = EventData(eventMethod: "shouldStart", data: dappMetaData)
        let data = try! JSONEncoder().encode(eventData)
        guard let json = String(data: data, encoding: .utf8) else { return }
        print(json)
        if self.events != nil {
            self.events!(json)
        }
    }
    
    private func convertData(para: Encodable) -> ValueType? {
        var data: Data?
        if let int = para as? Int {
            data = try! JSONEncoder().encode(int)
        } else if let double = para as? Double {
            data = try! JSONEncoder().encode(double)
        } else if let string = para as? String {
            data = try! JSONEncoder().encode(string)
        } else if let bool = para as? Bool {
            data = try! JSONEncoder().encode(bool)
        } else if let array = para as? [Encodable] {
            data = try! JSONEncoder().encode(array.map { self.convertData(para: $0) })
        } else if let dict = para as? [String: Encodable] {
            var newDict: [String: ValueType] = [:]
            for (key, value) in dict {
                newDict[key] = self.convertData(para: value)
            }
            data = try! JSONEncoder().encode(newDict)
        }
        
        if data != nil {
            return try! JSONDecoder().decode(ValueType.self, from: data!)
        } else {
            return nil
        }
    }
}

extension ParticleWalletConnectPlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.events = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.events = nil
        return nil
    }
}

struct RequestData: Encodable {
    let request_id: String
    let method: String
    let params: [ValueType]
}

struct EventData<T: Encodable>: Encodable {
    let eventMethod: String
    let data: T
}

struct DappMetaData: Encodable {
    var topic: String
    var name: String
    var icon: String
    var url: String
}

extension Dictionary {
    /// - Parameter prettify: set true to prettify string (default is false).
    /// - Returns: optional JSON String (if applicable).
    func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}
