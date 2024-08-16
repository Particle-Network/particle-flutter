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

typealias ShareCallback = (Any) -> Void

class ShareBase {
    static let shared: ShareBase = .init()

    func initialize(_ json: String) {
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

    func setChainInfo(_ json: String) -> Bool {
        let data = JSON(parseJSON: json)

        let chainId = data["chain_id"].intValue
        let chainName = data["chain_name"].stringValue.lowercased()
        let chainType: ChainType = chainName == "solana" ? .solana : .evm

        guard let chainInfo = ParticleNetwork.searchChainInfo(by: chainId, chainType: chainType) else {
            return false
        }
        ParticleNetwork.setChainInfo(chainInfo)
        return true
    }

    func setAppearance(_ json: String) {
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

    func setSecurityAccountConfig(_ json: String) {
        let data = JSON(parseJSON: json)
        let promptSettingWhenSign = data["prompt_setting_when_sign"].intValue
        let promptMasterPasswordSettingWhenLogin = data["prompt_master_password_setting_when_login"].intValue

        ParticleNetwork.setSecurityAccountConfig(config: .init(promptSettingWhenSign: promptSettingWhenSign, promptMasterPasswordSettingWhenLogin: promptMasterPasswordSettingWhenLogin))
    }

    func setFiatCoin(_ json: String) {
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

    func setThemeColor(_ json: String) {
        if let color = UIColor(hex: json) {
            ParticleNetwork.setThemeColor(color)
        }
    }

    func setCustomUIConfigJsonString(_ json: String) {
        do {
            try ParticleNetwork.setCustomUIConfigJsonString(json)
        } catch {
            print("setCustomUIConfigJsonString error \(error)")
        }
    }

    func setUnsupportCountries(_ json: String) {
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

    func setLanguage(_ json: String) {
        let language = json.lowercased()
        /*
         en,
         zh_hans, zh_cn
         zh_hant, zh_tw
         ja,
         ko
         */

        switch language {
        case "en":
            ParticleNetwork.setLanguage(.en)
        case "ja":
            ParticleNetwork.setLanguage(.ja)
        case "ko":
            ParticleNetwork.setLanguage(.ko)
        case "zh_hans", "zh_cn":
            ParticleNetwork.setLanguage(.zh_Hans)
        case "zh_hant", "zh_tw":
            ParticleNetwork.setLanguage(.zh_Hant)
        default:
            break
        }
    }

    func getChainInfo() -> String {
        let chainInfo = ParticleNetwork.getChainInfo()

        let jsonString = ["chain_name": chainInfo.name, "chain_id": chainInfo.chainId].jsonString() ?? ""
        return jsonString
    }

    func getLanguage() -> String {
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

        return language
    }
}
