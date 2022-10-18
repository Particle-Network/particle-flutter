//
//  BaseChannel.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

import Flutter
import Foundation
import ParticleNetworkBase
import RxSwift
import SwiftyJSON

public class BaseChannel: FlutterMethodChannel {
    let bag = DisposeBag()
    
    public enum Method: String {
        case initialize
        case setChainInfo
        case getChainInfo
    }
    
    public func setUp(vc: FlutterViewController) {
        let channel = FlutterMethodChannel(name: "base_bridge", binaryMessenger: vc.binaryMessenger)
        channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else { return }
            
            guard let method = Method(rawValue: call.method) else {
                result(FlutterMethodNotImplemented)
                return
            }
            
            let json = call.arguments
            
            switch method {
            case .initialize:
                self.initialize(json as? String)
            case .setChainInfo:
                self.setChainInfo(json as? String)
            case .getChainInfo:
                self.getChainInfo(flutterResult: result)
            }
        }
    }
}

// MARK: -  Methods

extension BaseChannel {
    public func initialize(_ json: String?) {
        guard let json = json else {
            return
        }
        
        let data = JSON(parseJSON: json)
        let name = data["chain_name"].stringValue.lowercased()
        let chainId = data["chain_id"].intValue
        guard let chainName = matchChain(name: name, chainId: chainId) else {
            return print("initialize error, can't find right chain for \(name), chainId \(chainId)")
        }
        let env = data["env"].stringValue.lowercased()
        var devEnv: ParticleNetwork.DevEnvironment = .production
        
        if env == "dev" {
            devEnv = .debug
        } else if env == "staging" {
            devEnv = .staging
        } else if env == "production" {
            devEnv = .production
        }
        
        let config = ParticleNetworkConfiguration(chainInfo: chainName, devEnv: devEnv)
        ParticleNetwork.initialize(config: config)
    }
    
    public func setChainInfo(_ json: String?) {
        guard let json = json else {
            return
        }
        
        let data = JSON(parseJSON: json)
        let name = data["chain_name"].stringValue.lowercased()
        let chainId = data["chain_id"].intValue
        guard let chainInfo = matchChain(name: name, chainId: chainId) else { return }
        ParticleNetwork.setChainInfo(chainInfo)
    }
    
    public func getChainInfo(flutterResult: FlutterResult) {
        let chainInfo = ParticleNetwork.getChainInfo()
        
        let jsonString = ["chain_name": chainInfo.name, "chain_id": chainInfo.chainId, "chain_id_name": chainInfo.network].jsonString() ?? ""
        
        flutterResult(jsonString)
    }
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
