//
//  ParticleBasePlugin.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

import Base58_swift
import Flutter
import Foundation
import ParticleNetworkBase
import ParticleNetworkChains
import RxSwift
import SwiftyJSON

public class ParticleBasePlugin: NSObject, FlutterPlugin {
    let bag = DisposeBag()
    
    public enum Method: String {
        case initialize
        case setChainInfo
        case getChainInfo
        case setSecurityAccountConfig
        case setLanguage
        case getLanguage
        case setAppearance
        case setFiatCoin
        case setCustomUIConfigJsonString
        case setThemeColor
        case setUnsupportCountries
        
        var containsParameter: Bool {
            switch self {
            case .initialize, .setChainInfo, .setSecurityAccountConfig, .setLanguage, .setAppearance, .setFiatCoin, .setCustomUIConfigJsonString, .setThemeColor, .setUnsupportCountries:
                return true
            
            case .getChainInfo, .getLanguage:
                return false
            }
        }
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "base_bridge", binaryMessenger: registrar.messenger())
        
        let instance = ParticleBasePlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = ParticleBasePlugin.Method(rawValue: call.method) else {
            result(FlutterMethodNotImplemented)
            return
        }
        
        let json = call.arguments
        if method.containsParameter, (json as? String?) == nil, (json as? Bool) == nil {
            let response = ParticleNetwork.ResponseError(code: nil, message: "parameters is required")
            let statusModel = PNStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            result(json)
        }
        
        switch method {
        case .initialize:
            ShareBase.shared.initialize(json as! String)
        case .setChainInfo:
            let value = ShareBase.shared.setChainInfo(json as! String)
            result(value)
        case .getChainInfo:
            let value = ShareBase.shared.getChainInfo()
            result(value)
        case .setLanguage:
            ShareBase.shared.setLanguage(json as! String)
        case .getLanguage:
            let value = ShareBase.shared.getLanguage()
            result(value)
        case .setAppearance:
            ShareBase.shared.setAppearance(json as! String)
        case .setFiatCoin:
            ShareBase.shared.setFiatCoin(json as! String)
        case .setSecurityAccountConfig:
            ShareBase.shared.setSecurityAccountConfig(json as! String)
        case .setCustomUIConfigJsonString:
            ShareBase.shared.setCustomUIConfigJsonString(json as! String)
        case .setThemeColor:
            ShareBase.shared.setThemeColor(json as! String)
        case .setUnsupportCountries:
            ShareBase.shared.setUnsupportCountries(json as! String)
        }
    }
}
