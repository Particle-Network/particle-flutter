//
//  ParticleWalletConnectPlugin.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

import Flutter
import Foundation
import ParticleWalletConnect
import SwiftyJSON
import WalletConnectSwift

public class ParticleWalletConnectPlugin: NSObject, FlutterPlugin {
    var requestFlutterResult: FlutterResult?
    var didConnectFlutterResult: FlutterResult?
    var didDisconnectFlutterResult: FlutterResult?
    
    var shouldStartCallBacks: [String: (String, Int) -> Void] = [:]
    var requestCallBacks: [String: (WCResult<Data?>) -> Void] = [:]
    var connectFlutterResult: FlutterResult?
    
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
        case subscriptRequest
        case handleRequest
        case subscriptDidDisconnectSession
        case subscriptDidConnectSession
        case subscriptShouldStartSession
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "wallet_connect_bridge", binaryMessenger: registrar.messenger())
        
        let instance = ParticleWalletConnectPlugin()
        
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
        case .subscriptRequest:
            self.subscriptRequest(flutterResult: result)
        case .handleRequest:
            self.handleRequest(json as? String)
        case .subscriptDidDisconnectSession:
            self.subscriptDidDisconnectSession(flutterResult: result)
        case .subscriptDidConnectSession:
            self.subscriptDidConnectSession(flutterResult: result)
        case .subscriptShouldStartSession:
            self.subscriptShouldStartSession(flutterResult: result)
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
        self.requestFlutterResult = flutterResult
//        let code1 = "wc:AC571703-958B-4816-BBE1-2F5FBBD36086@1?bridge=https%3A%2F%2Fbridge.walletconnect.org%2F&key=5146dafb25399dbec29a03df1c39f9405a646fe98ce0380e2fa13401a102928d"
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
        flutterResult(data)
    }
    
    func getAllSessions(flutterResult: FlutterResult) {
        let sessions = ParticleWalletConnect.shared.getAllSessions()
        let dappMetaDatas = sessions.map {
            getDapp(from: $0)
        }
        
        let data = try! JSONEncoder().encode(dappMetaDatas)
        flutterResult(data)
    }
    
    func startSession(_ json: String?) {
        guard let json = json else {
            return
        }
        let data = JSON(parseJSON: json)
        let topic = data["topic"].stringValue
        let publicAddress = data["public_address"].stringValue
        let chainId = data["chain_id"].intValue
        if self.shouldStartCallBacks.keys.contains(topic) {
            let shouldStartCallBack = self.shouldStartCallBacks[topic]
            shouldStartCallBack?(publicAddress, chainId)
            self.shouldStartCallBacks.removeValue(forKey: topic)
        }
    }
    
    func subscriptRequest(flutterResult: @escaping FlutterResult) {
        self.requestFlutterResult = flutterResult
    }
    
    func handleRequest(_ json: String?) {
        guard let json = json else {
            return
        }
        let data = JSON(parseJSON: json)
        let requestId = data["request_id"].stringValue
        let isSuccess = data["isSuccess"].boolValue
        if isSuccess {
            //
            let result = data["data"].arrayValue
            if self.requestCallBacks.keys.contains(requestId) {
                let requestCallBack = self.requestCallBacks[requestId]
                let encoded = try? JSONEncoder().encode(result)
                requestCallBack?(.success(encoded))
                self.requestCallBacks.removeValue(forKey: requestId)
            }
            
        } else {
            // error
            let code = data["data"]["code"].int
            let message = data["data"]["message"].string
            let errorData = data["data"]["data"].string
            let error = WCResponseError(code: code, message: message, data: errorData)
            if self.requestCallBacks.keys.contains(requestId) {
                let requestCallBack = self.requestCallBacks[requestId]
                requestCallBack?(.failure(error))
                self.requestCallBacks.removeValue(forKey: requestId)
            }
        }
    }
    
    func subscriptDidDisconnectSession(flutterResult: @escaping FlutterResult) {
        self.didDisconnectFlutterResult = flutterResult
    }
    
    func subscriptDidConnectSession(flutterResult: @escaping FlutterResult) {
        self.didConnectFlutterResult = flutterResult
    }
    
    func subscriptShouldStartSession(flutterResult: @escaping FlutterResult) {
    }
    
    private func getDapp(from session: Session) -> DappMetaData {
        return DappMetaData(topic: session.url.topic, name: session.dAppInfo.peerMeta.name, icon: session.dAppInfo.peerMeta.icons.first?.absoluteString ?? "", url: session.dAppInfo.peerMeta.url.absoluteString)
    }
}

extension ParticleWalletConnectPlugin: ParticleWalletConnectDelegate {
    public func request(topic: String, method: String, params: [Encodable], completion: @escaping (WCResult<Data?>) -> Void) {
        if let flutterResult = self.requestFlutterResult {
            let requestId = UUID().uuidString
            let dict: [String: Any] = ["request_id": requestId,
                                       "method": method,
                                       "params": params]
            let json = dict.jsonString()
            self.requestCallBacks[requestId] = completion
            flutterResult(json)
        }
    }
    
    public func didConnectSession(_ session: WalletConnectSwift.Session) {
        if let flutterResult = self.didConnectFlutterResult {
            let dappMetaData = self.getDapp(from: session)
            let data = try! JSONEncoder().encode(dappMetaData)
            flutterResult(data)
        }
    }
    
    public func didDisconnect(_ session: WalletConnectSwift.Session) {
        if let flutterResult = self.didDisconnectFlutterResult {
            let dappMetaData = self.getDapp(from: session)
            let data = try! JSONEncoder().encode(dappMetaData)
            flutterResult(data)
        }
    }
    
    public func shouldStartSession(_ session: WalletConnectSwift.Session, completion: @escaping (String, Int) -> Void) {
        self.shouldStartCallBacks[session.url.topic] = completion
        if let fultterResult = self.connectFlutterResult {
            let dappMetaData = self.getDapp(from: session)
            let data = try! JSONEncoder().encode(dappMetaData)
            fultterResult(data)
        }
    }
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
