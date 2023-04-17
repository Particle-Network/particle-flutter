//
//  ParticleWalletPlugin.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

import Flutter
import Foundation
import ParticleNetworkBase
import ParticleWalletGUI
import RxSwift
import SwiftyJSON

public class ParticleWalletPlugin: NSObject, FlutterPlugin {
    let bag = DisposeBag()

    public enum Method: String {
        case navigatorWallet
        case navigatorTokenReceive
        case navigatorTokenSend
        case navigatorTokenTransactionRecords
        case navigatorNFTSend
        case navigatorNFTDetails
        case navigatorPay
        case navigatorBuyCrypto
        case navigatorLoginList
        case navigatorSwap
        case navigatorDappBrowser
        case showTestNetwork
        case showManageWallet
        case supportChain
        case enablePay
        case getEnablePay
        case enableSwap
        case getEnableSwap
        case switchWallet
        case setLanguage
        case supportWalletConnect
        case supportDappBrowser
        case showLanguageSetting
        case showAppearanceSetting
        case setSupportAddToken
        case setDisplayTokenAddresses
        case setDisplayNFTContractAddresses
        case setPriorityTokenAddresses
        case setPriorityNFTContractAddresses
        case setFiatCoin
        case loadCustomUIJsonString
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "wallet_bridge", binaryMessenger: registrar.messenger())

        let instance = ParticleWalletPlugin()

        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = Method(rawValue: call.method) else {
            result(FlutterMethodNotImplemented)
            return
        }

        let json = call.arguments

        switch method {
        case .navigatorWallet:
            self.navigatorWallet((json as? Int) ?? 0)
        case .navigatorTokenReceive:
            self.navigatorTokenReceive(json as? String)
        case .navigatorTokenSend:
            self.navigatorTokenSend(json as? String)
        case .navigatorTokenTransactionRecords:
            self.navigatorTokenTransactionRecords(json as? String)
        case .navigatorNFTSend:
            self.navigatorNFTSend(json as? String)
        case .navigatorNFTDetails:
            self.navigatorNFTDetails(json as? String)
        case .navigatorPay:
            self.navigatorPay()
        case .navigatorBuyCrypto:
            self.navigatorBuyCrypto(json as? String)
        case .navigatorLoginList:
            self.navigatorLoginList(flutterResult: result)
        case .navigatorSwap:
            self.navigatorSwap(json as? String)
        case .navigatorDappBrowser:
            self.navigatorDappBrowser(json as? String)
        case .showTestNetwork:
            self.showTestNetwork((json as? Bool) ?? false)
        case .showManageWallet:
            self.showManageWallet((json as? Bool) ?? true)
        case .supportChain:
            self.supportChain(json as? String)
        case .enablePay:
            self.enablePay((json as? Bool) ?? true)
        case .getEnablePay:
            self.getEnablePay(flutterResult: result)
        case .enableSwap:
            self.enableSwap((json as? Bool) ?? true)
        case .getEnableSwap:
            self.getEnableSwap(flutterResult: result)
        case .switchWallet:
            self.switchWallet(json as? String, flutterResult: result)
        case .setLanguage:
            self.setLanguage(json as? String)
        case .supportWalletConnect:
            self.supportWalletConnect((json as? Bool) ?? true)
        case .supportDappBrowser:
            self.supportDappBrowser((json as? Bool) ?? true)
        case .showLanguageSetting:
            self.showLanguageSetting((json as? Bool) ?? true)
        case .showAppearanceSetting:
            self.showAppearanceSetting((json as? Bool) ?? true)
        case .setSupportAddToken:
            self.setSupportAddToken((json as? Bool) ?? true)
        case .setDisplayTokenAddresses:
            self.setDisplayTokenAddresses(json as? String)
        case .setDisplayNFTContractAddresses:
            self.setDisplayNFTContractAddresses(json as? String)
        case .setPriorityTokenAddresses:
            self.setPriorityTokenAddresses(json as? String)
        case .setPriorityNFTContractAddresses:
            self.setPriorityNFTContractAddresses(json as? String)
        case .setFiatCoin:
            self.setFiatCoin(json as? String)
        case .loadCustomUIJsonString:
            self.loadCustomUIJsonString(json as? String)
        }
    }
}

// MARK: -  Methods

extension ParticleWalletPlugin {
    func navigatorWallet(_ display: Int) {
        if display != 0 {
            PNRouter.navigatorWallet(display: .nft)
        } else {
            PNRouter.navigatorWallet(display: .token)
        }
    }

    func navigatorTokenReceive(_ json: String?) {
        PNRouter.navigatorTokenReceive(tokenReceiveConfig: TokenReceiveConfig(tokenAddress: json))
    }

    func navigatorTokenSend(_ json: String?) {
        if let json = json {
            let data = JSON(parseJSON: json)
            let tokenAddress = data["token_address"].string
            let toAddress = data["to_address"].string
            let amount = data["amount"].string
            let config = TokenSendConfig(tokenAddress: tokenAddress, toAddress: toAddress, amountString: amount)

            PNRouter.navigatorTokenSend(tokenSendConfig: config)
        } else {
            PNRouter.navigatorTokenSend()
        }
    }

    func navigatorTokenTransactionRecords(_ json: String?) {
        if let json = json {
            let config = TokenTransactionRecordsConfig(tokenAddress: json)
            PNRouter.navigatorTokenTransactionRecords(tokenTransactionRecordsConfig: config)
        } else {
            PNRouter.navigatorTokenTransactionRecords()
        }
    }

    func navigatorNFTSend(_ json: String?) {
        guard let json = json else { return }

        let data = JSON(parseJSON: json)
        let address = data["mint"].stringValue
        let tokenId = data["token_id"].stringValue
        let toAddress = data["receiver_address"].string
        let amount = data["amount"].int
        let config = NFTSendConfig(address: address, toAddress: toAddress, tokenId: tokenId, amount: UInt(amount ?? 1))
        PNRouter.navigatorNFTSend(nftSendConfig: config)
    }

    func navigatorNFTDetails(_ json: String?) {
        guard let json = json else { return }

        let data = JSON(parseJSON: json)
        let address = data["mint"].stringValue
        let tokenId = data["token_id"].stringValue
        let config = NFTDetailsConfig(address: address, tokenId: tokenId)
        PNRouter.navigatorNFTDetails(nftDetailsConfig: config)
    }

    func navigatorPay() {
        PNRouter.navigatorBuy()
    }

    func navigatorBuyCrypto(_ json: String?) {
        guard let json = json else { return }
        let data = JSON(parseJSON: json)
        let walletAddress = data["wallet_address"].string
        let networkString = data["network"].stringValue.lowercased()
        var network: OpenBuyNetwork?

        if networkString == "solana" {
            network = .solana
        } else if networkString == "ethereum" {
            network = .ethereum
        } else if networkString == "binancesmartchain" {
            network = .binanceSmartChain
        } else if networkString == "optimism" {
            network = .optimism
        } else if networkString == "polygon" {
            network = .polygon
        } else if networkString == "tron" {
            network = .tron
        } else if networkString == "arbitrumOne" {
            network = .arbitrumOne
        } else {
            network = nil
        }
        let fiatCoin = data["fiat_coin"].string
        let fiatAmt = data["fiat_amt"].int
        let cryptoCoin = data["crypto_coin"].string
        let fixCryptoCoin = data["fix_crypto_coin"].boolValue
        let fixFiatAmt = data["fix_fiat_amt"].boolValue
        let fixFiatCoin = data["fix_fiat_coin"].boolValue
        let theme = data["theme"].stringValue.lowercased()
        let language = self.getLanguage(from: data["language"].stringValue.lowercased())

        var buyConfig = BuyCryptoConfig()
        buyConfig.network = network
        buyConfig.walletAddress = walletAddress
        buyConfig.cryptoCoin = cryptoCoin
        buyConfig.fiatAmt = fiatAmt
        if fiatCoin != nil {
            buyConfig.fiatCoin = fiatCoin!
        }
        buyConfig.fixCryptoCoin = fixCryptoCoin
        buyConfig.fixFiatCoin = fixFiatCoin
        buyConfig.fixFiatAmt = fixFiatAmt
        buyConfig.theme = theme
        buyConfig.language = language.webString

        PNRouter.navigatorBuy(buyCryptoConfig: buyConfig)
    }

    func navigatorLoginList(flutterResult: @escaping FlutterResult) {
        PNRouter.navigatorLoginList().subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            case .success(let (walletType, account)):
                guard let account = account else { return }

                let loginListModel = FlutterLoginListModel(walletType: walletType.stringValue, account: account)
                let statusModel = FlutterStatusModel(status: true, data: loginListModel)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            }
        }.disposed(by: self.bag)
    }

    func navigatorSwap(_ json: String?) {
        if let json = json {
            let data = JSON(parseJSON: json)
            let fromTokenAddress = data["from_token_address"].string
            let toTokenAddress = data["to_token_address"].string
            let amount = data["amount"].string
            let config = SwapConfig(fromTokenAddress: fromTokenAddress, toTokenAddress: toTokenAddress, fromTokenAmountString: amount)

            PNRouter.navigatorSwap(swapConfig: config)
        } else {
            PNRouter.navigatorSwap()
        }
    }

    func navigatorDappBrowser(_ json: String?) {
        if let json = json {
            let data = JSON(parseJSON: json)
            let urlStr = data["url"].stringValue
            if let url = URL(string: urlStr) {
                PNRouter.navigatorDappBrowser(url: url)
            } else {
                PNRouter.navigatorDappBrowser(url: nil)
            }
        } else {
            PNRouter.navigatorDappBrowser(url: nil)
        }
    }

    func showTestNetwork(_ isShow: Bool) {
        ParticleWalletGUI.showTestNetwork(isShow)
    }

    func showManageWallet(_ isShow: Bool) {
        ParticleWalletGUI.showManageWallet(isShow)
    }

    func supportChain(_ json: String?) {
        guard let json = json else { return }
        let chains = JSON(parseJSON: json).arrayValue.map {
            $0["chain_name"].stringValue.lowercased()
        }.compactMap {
            self.matchChain(name: $0)
        }
        ParticleWalletGUI.supportChain(chains)
    }

    func enablePay(_ enable: Bool) {
        ParticleWalletGUI.enablePay(enable)
    }

    func getEnablePay(flutterResult: @escaping FlutterResult) {
        flutterResult(ParticleWalletGUI.getEnablePay())
    }

    func enableSwap(_ enable: Bool) {
        ParticleWalletGUI.enableSwap(enable)
    }

    func getEnableSwap(flutterResult: @escaping FlutterResult) {
        flutterResult(ParticleWalletGUI.getEnableSwap())
    }

    func switchWallet(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "",
                                       message: "json is nil",
                                       details: nil))
            return
        }

        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue

        if let walletType = map2WalletType(from: walletTypeString) {
            let result = ParticleWalletGUI.switchWallet(walletType: walletType, publicAddress: publicAddress)

//            let statusModel = FlutterStatusModel(status: true, data: result == true ? "success" : "failed")
//
//            let data = try! JSONEncoder().encode(statusModel)
//            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(result)
        } else {
            print("walletType \(walletTypeString) is not existed")
//            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not existed", data: nil)
//            let statusModel = FlutterStatusModel(status: false, data: response)
//            let data = try! JSONEncoder().encode(statusModel)
//            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(false)
        }
    }

    func setLanguage(_ json: String?) {
        guard let json = json else {
            return
        }
        let language = self.getLanguage(from: json)
        ParticleWalletGUI.setLanguage(language)
    }

    private func getLanguage(from json: String) -> Language {
        /*
         en,
         zh_hans,
         zh_hant,
         ja,
         ko
         */
        var language: Language = .en
        if json.lowercased() == "en" {
            language = .en
        } else if json.lowercased() == "zh_hans" {
            language = .zh_Hans
        } else if json.lowercased() == "zh_hant" {
            language = .zh_Hant
        } else if json.lowercased() == "ja" {
            language = .ja
        } else if json.lowercased() == "ko" {
            language = .ko
        }
        return language
    }

    func supportWalletConnect(_ enable: Bool) {
        ParticleWalletGUI.supportWalletConnect(enable)
    }

    func supportDappBrowser(_ enable: Bool) {
        ParticleWalletGUI.supportDappBrowser(enable)
    }

    func showLanguageSetting(_ isShow: Bool) {
        ParticleWalletGUI.showLanguageSetting(isShow)
    }

    func showAppearanceSetting(_ isShow: Bool) {
        ParticleWalletGUI.showAppearanceSetting(isShow)
    }

    func setSupportAddToken(_ isShow: Bool) {
        ParticleWalletGUI.setSupportAddToken(isShow)
    }

    func setDisplayTokenAddresses(_ json: String?) {
        guard let json = json else {
            return
        }
        let data = JSON(parseJSON: json)
        let tokenAddresses = data.arrayValue.map {
            $0.stringValue
        }
        ParticleWalletGUI.setDisplayTokenAddresses(tokenAddresses)
    }

    func setDisplayNFTContractAddresses(_ json: String?) {
        guard let json = json else {
            return
        }
        let data = JSON(parseJSON: json)
        let nftContractAddresses = data.arrayValue.map {
            $0.stringValue
        }
        ParticleWalletGUI.setDisplayNFTContractAddresses(nftContractAddresses)
    }

    func setPriorityTokenAddresses(_ json: String?) {
        guard let json = json else {
            return
        }
        let data = JSON(parseJSON: json)
        let tokenAddresses = data.arrayValue.map {
            $0.stringValue
        }
        ParticleWalletGUI.setPriorityTokenAddresses(tokenAddresses)
    }

    func setPriorityNFTContractAddresses(_ json: String?) {
        guard let json = json else {
            return
        }
        let data = JSON(parseJSON: json)
        let nftContractAddresses = data.arrayValue.map {
            $0.stringValue
        }
        ParticleWalletGUI.setPriorityNFTContractAddresses(nftContractAddresses)
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
            ParticleWalletGUI.setFiatCoin("USD")
        } else if json.lowercased() == "cny" {
            ParticleWalletGUI.setFiatCoin("CNY")
        } else if json.lowercased() == "jpy" {
            ParticleWalletGUI.setFiatCoin("JPY")
        } else if json.lowercased() == "hkd" {
            ParticleWalletGUI.setFiatCoin("HKD")
        } else if json.lowercased() == "inr" {
            ParticleWalletGUI.setFiatCoin("INR")
        } else if json.lowercased() == "krw" {
            ParticleWalletGUI.setFiatCoin("KRW")
        }
    }

    func loadCustomUIJsonString(_ json: String?) {
        guard let json = json else {
            return
        }
        do {
            try ParticleWalletGUI.loadCustomUIJsonString(json)
        } catch {
            print(error)
        }
    }
}
