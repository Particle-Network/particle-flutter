//
//  ShareBase.swift
//  particle_base
//
//  Created by link on 14/08/2024.
//

import Foundation
import ParticleNetworkBase
import ParticleNetworkChains
import SwiftyJSON

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

extension NSObject {
    func ResponseFromError(_ error: Error) -> PNResponseError {
        if let responseError = error as? ParticleNetwork.ResponseError {
            return PNResponseError(code: responseError.code, message: responseError.message ?? "", data: responseError.data)
        } else {
            return PNResponseError(code: nil, message: String(describing: error), data: nil)
        }
    }
}

struct PNResponseError: Codable {
    let code: Int?
    let message: String?
    let data: String?
}

struct PNStatusModel<T: Codable>: Codable {
    let status: Bool
    let data: T
}

typealias ShareCallback = (Any) -> Void

enum ShareBase {
    static func initialize(_ json: String) {
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

    static func setChainInfo(_ json: String, callback: @escaping ShareCallback) {
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

    static func setAppearance(_ json: String) {
        let appearance = json.lowercased()
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

    static func setSecurityAccountConfig(_ json: String) {
        let data = JSON(parseJSON: json)
        let promptSettingWhenSign = data["prompt_setting_when_sign"].intValue
        let promptMasterPasswordSettingWhenLogin = data["prompt_master_password_setting_when_login"].intValue

        ParticleNetwork.setSecurityAccountConfig(config: .init(promptSettingWhenSign: promptSettingWhenSign, promptMasterPasswordSettingWhenLogin: promptMasterPasswordSettingWhenLogin))
    }

    static func setFiatCoin(_ json: String) {
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

    static func setThemeColor(_ json: String) {
        if let color = UIColor(hex: json) {
            ParticleNetwork.setThemeColor(color)
        }
    }

    static func setCustomUIConfigJsonString(_ json: String) {
        do {
            try ParticleNetwork.setCustomUIConfigJsonString(json)
        } catch {
            print("setCustomUIConfigJsonString error \(error)")
        }
    }

    func setUnsupportCountries(_ json: String?) {
        guard let json = json else {
            return
        }
        let countries = JSON(parseJSON: json).arrayValue.map {
            $0.stringValue.lowercased()
        }
        ParticleNetwork.setCountryFilter {
            if countries.contains($0.iso.lowercased()) {
                return false
            } else {
                return true
            }
        }
    }

    static func setLanguage(_ json: String) {
        let lanaguage = json.lowercased()
        /*
         en,
         zh_hans,
         zh_hant,
         ja,
         ko
         */
        if lanaguage == "en" {
            ParticleNetwork.setLanguage(.en)
        } else if lanaguage == "zh_hans" {
            ParticleNetwork.setLanguage(.zh_Hans)
        } else if lanaguage == "zh_hant" {
            ParticleNetwork.setLanguage(.zh_Hant)
        } else if lanaguage == "ja" {
            ParticleNetwork.setLanguage(.ja)
        } else if lanaguage == "ko" {
            ParticleNetwork.setLanguage(.ko)
        }
    }

    static func getChainInfo(_ callback: ShareCallback) {
        let chainInfo = ParticleNetwork.getChainInfo()

        let jsonString = ["chain_name": chainInfo.name, "chain_id": chainInfo.chainId].jsonString() ?? ""

        callback(jsonString)
    }

    static func getLanguage(_ callback: @escaping ShareCallback) {
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
}


