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

public typealias ParticleCallback = FlutterResult

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
        
        switch method {
        case .initialize:
            self.initialize(json as? String)
        case .setChainInfo:
            self.setChainInfo(json as? String, callback: result)
        case .getChainInfo:
            self.getChainInfo(result)
        case .setLanguage:
            self.setLanguage(json as? String)
        case .getLanguage:
            self.getLanguage(result)
        case .setAppearance:
            self.setAppearance(json as? String)
        case .setFiatCoin:
            self.setFiatCoin(json as? String)
        case .setSecurityAccountConfig:
            self.setSecurityAccountConfig(json as? String)
        }
    }
}

// MARK: -  Methods

public extension ParticleBasePlugin {
    func initialize(_ json: String?) {
        guard let json = json else {
            return
        }
        
        let data = JSON(parseJSON: json)
        
        let chainId = data["chain_id"].intValue
        let chainName = data["chain_name"].stringValue.lowercased()
        let chainType: ChainType = chainName == "solana" ? .solana : .evm
        guard let chainInfo = ParticleNetwork.searchChainInfo(by: chainId, chainType: chainType) else {
            return print("initialize error, can't find right chain for \(chainName), chainId \(chainId)")
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
        
        let config = ParticleNetworkConfiguration(chainInfo: chainInfo, devEnv: devEnv)
        ParticleNetwork.initialize(config: config)
    }
    
    func setChainInfo(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else {
            return
        }
        
        let data = JSON(parseJSON: json)
        
        let chainId = data["chain_id"].intValue
        let chainName = data["chain_name"].stringValue.lowercased()
        let chainType: ChainType = chainName == "solana" ? .solana : .evm
        
        guard let chainInfo = ParticleNetwork.searchChainInfo(by: chainId, chainType: chainType) else {
            callback(false)
            return
        }
        ParticleNetwork.setChainInfo(chainInfo)
        callback(true)
    }

    func getChainInfo(_ callback: FlutterResult) {
        let chainInfo = ParticleNetwork.getChainInfo()
        
        let jsonString = ["chain_name": chainInfo.name, "chain_id": chainInfo.chainId, "chain_id_name": chainInfo.network].jsonString() ?? ""
        
        callback(jsonString)
    }

    func setAppearance(_ json: String?) {
        guard let appearance = json?.lowercased() else {
            return
        }
        /**
         SYSTEM,
         LIGHT,
         DARK,
         */
        if appearance == "system" {
            ParticleNetwork.setAppearance(UIUserInterfaceStyle.unspecified)
        } else if appearance == "light" {
            ParticleNetwork.setAppearance(UIUserInterfaceStyle.light)
        } else if appearance == "dark" {
            ParticleNetwork.setAppearance(UIUserInterfaceStyle.dark)
        }
    }
    
    func setSecurityAccountConfig(_ json: String?) {
        guard let json = json else {
            return
        }
        let data = JSON(parseJSON: json)
        let promptSettingWhenSign = data["prompt_setting_when_sign"].intValue
        let promptMasterPasswordSettingWhenLogin = data["prompt_master_password_setting_when_login"].intValue
        
        ParticleNetwork.setSecurityAccountConfig(config: .init(promptSettingWhenSign: promptSettingWhenSign, promptMasterPasswordSettingWhenLogin: promptMasterPasswordSettingWhenLogin))
    }
    
    func setLanguage(_ json: String?) {
        guard let json = json else {
            return
        }
        
        /*
         en,
         zh_hans,
         zh_hant,
         ja,
         ko
         */
        if json.lowercased() == "en" {
            ParticleNetwork.setLanguage(.en)
        } else if json.lowercased() == "zh_hans" {
            ParticleNetwork.setLanguage(.zh_Hans)
        } else if json.lowercased() == "zh_hant" {
            ParticleNetwork.setLanguage(.zh_Hant)
        } else if json.lowercased() == "ja" {
            ParticleNetwork.setLanguage(.ja)
        } else if json.lowercased() == "ko" {
            ParticleNetwork.setLanguage(.ko)
        }
    }
    
    func getLanguage(_ callback: @escaping ParticleCallback) {
        var language = ""
        
        switch ParticleNetwork.getLanguage() {
        case .en:
            language = "en"
        case .zh_Hans:
            language = "zh_hans"
        case .zh_Hant:
            language = "zh_hant"
        case .ja:
            language = "ja"
        case .ko:
            language = "ko"
        default:
            language = "en"
        }
        
        callback(language)
    }
    
    func setFiatCoin(_ json: String?) {
        guard let json = json else {
            return
        }
        /*
             USD,
             CNY,
             JPY,
             HKD,
             INR,
             KRW,
         */
        if json.lowercased() == "usd" {
            ParticleNetwork.setFiatCoin(.usd)
        } else if json.lowercased() == "cny" {
            ParticleNetwork.setFiatCoin(.cny)
        } else if json.lowercased() == "jpy" {
            ParticleNetwork.setFiatCoin(.jpy)
        } else if json.lowercased() == "hkd" {
            ParticleNetwork.setFiatCoin(.hkd)
        } else if json.lowercased() == "inr" {
            ParticleNetwork.setFiatCoin(.inr)
        } else if json.lowercased() == "krw" {
            ParticleNetwork.setFiatCoin(.krw)
        }
    }
    
    func setThemeColor(_ json: String?) {
        guard let json = json else {
            return
        }
        if let color = UIColor(hex: json) {
            ParticleNetwork.setThemeColor(color)
        }
    }
    
    func setCustomUIConfigJsonString(_ json: String?) {
        guard let json = json else {
            return
        }
        do {
            try ParticleNetwork.setCustomUIConfigJsonString(json)
        } catch {
            print("setCustomUIConfigJsonString error \(error)")
                  
        }
    }
}
