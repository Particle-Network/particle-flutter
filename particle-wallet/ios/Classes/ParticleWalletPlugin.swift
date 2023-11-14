//
//  ParticleWalletPlugin.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

import ConnectCommon
import Flutter
import Foundation
import ParticleNetworkBase
import ParticleWalletConnect
import ParticleWalletGUI
import RxSwift
import SwiftyJSON

public typealias ParticleCallback = FlutterResult

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
        case setShowTestNetwork
        case setShowManageWallet
        case setSupportChain
        case setPayDisabled
        case getPayDisabled
        case setSwapDisabled
        case getSwapDisabled
        case switchWallet
        case setSupportDappBrowser
        case setShowLanguageSetting
        case setShowAppearanceSetting
        case setShowSmartAccountSetting
        case setSupportAddToken
        case setDisplayTokenAddresses
        case setDisplayNFTContractAddresses
        case setPriorityTokenAddresses
        case setPriorityNFTContractAddresses
        case loadCustomUIJsonString

        // WalletConnectV2
        case setSupportWalletConnect
        case setWalletConnectV2ProjectId
        case initializeWalletMetaData

        case setCustomWalletName
        case setCustomLocalizable
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
            self.navigatorLoginList(result)
        case .navigatorSwap:
            self.navigatorSwap(json as? String)
        case .navigatorDappBrowser:
            self.navigatorDappBrowser(json as? String)
        case .setShowTestNetwork:
            self.setShowTestNetwork((json as? Bool) ?? false)
        case .setShowSmartAccountSetting:
            self.setShowSmartAccountSetting((json as? Bool) ?? false)
        case .setShowManageWallet:
            self.setShowManageWallet((json as? Bool) ?? true)
        case .setSupportChain:
            self.setSupportChain(json as? String)
        case .setPayDisabled:
            self.setPayDisabled((json as? Bool) ?? true)
        case .getPayDisabled:
            self.getPayDisabled(flutterResult: result)
        case .setSwapDisabled:
            self.setSwapDisabled((json as? Bool) ?? true)
        case .getSwapDisabled:
            self.getSwapDisabled(flutterResult: result)
        case .switchWallet:
            self.switchWallet(json as? String, callback: result)
        case .setSupportWalletConnect:
            self.setSupportWalletConnect((json as? Bool) ?? true)
        case .setSupportDappBrowser:
            self.setSupportDappBrowser((json as? Bool) ?? true)
        case .setShowLanguageSetting:
            self.setShowLanguageSetting((json as? Bool) ?? true)
        case .setShowAppearanceSetting:
            self.setShowAppearanceSetting((json as? Bool) ?? true)
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
        case .loadCustomUIJsonString:
            self.loadCustomUIJsonString(json as? String)
        case .setWalletConnectV2ProjectId:
            self.setWalletConnectV2ProjectId(json as? String)
        case .initializeWalletMetaData:
            self.initializeWalletMetaData(json as? String)

        case .setCustomWalletName:
            self.setCustomWalletName(json as? String)
        case .setCustomLocalizable:
            self.setCustomLocalizable(json as? String)
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
        let config = NFTSendConfig(address: address, toAddress: toAddress, tokenId: tokenId, amount: BInt(amount ?? 1))
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
        } else if networkString == "arbitrumone" {
            network = .arbitrumOne
        } else if networkString == "avalanche" {
            network = .avalanche
        } else if networkString == "celo" {
            network = .celo
        } else if networkString == "zksync" {
            network = .zkSync
        } else {
            network = nil
        }
        let chainInfo = ParticleNetwork.getChainInfo()
        if network == nil {
            switch chainInfo.chain {
            case .solana:
                network = OpenBuyNetwork.solana
            case .ethereum:
                network = OpenBuyNetwork.ethereum
            case .bsc:
                network = OpenBuyNetwork.binanceSmartChain
            case .optimism:
                network = OpenBuyNetwork.optimism
            case .polygon:
                network = OpenBuyNetwork.polygon
            case .tron:
                network = OpenBuyNetwork.tron
            case .arbitrum:
                if chainInfo == .arbitrum(.one) {
                    network = OpenBuyNetwork.arbitrumOne
                } else {
                    network = nil
                }
            case .avalanche:
                network = OpenBuyNetwork.avalanche
            case .celo:
                network = OpenBuyNetwork.celo
            case .zkSync:
                network = OpenBuyNetwork.zkSync
            default:
                network = nil
            }
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
        buyConfig.cryptoCoin = cryptoCoin ?? chainInfo.nativeToken.symbol
        buyConfig.fiatAmt = fiatAmt
        if fiatCoin != nil {
            buyConfig.fiatCoin = fiatCoin!
        }
        buyConfig.fixCryptoCoin = fixCryptoCoin
        buyConfig.fixFiatCoin = fixFiatCoin
        buyConfig.fixFiatAmt = fixFiatAmt
        buyConfig.theme = theme
        buyConfig.language = language?.webString ?? Language.en.webString

        let modalStyleString = data["modal_style"].stringValue.lowercased()
        var modalStyle: ParticleGUIModalStyle
        if modalStyleString == "fullscreen" {
            modalStyle = .fullScreen
        } else {
            modalStyle = .pageSheet
        }

        PNRouter.navigatorBuy(buyCryptoConfig: buyConfig, modalStyle: modalStyle)
    }

    func navigatorLoginList(_ callback: @escaping ParticleCallback) {
        subscribeAndCallback(observable: PNRouter.navigatorLoginList().map { walletType, account in
            let loginListModel = FlutterLoginListModel(walletType: walletType.stringValue, account: account)
            return loginListModel
        }, callback: callback)
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

    func setShowTestNetwork(_ isShow: Bool) {
        ParticleWalletGUI.setShowTestNetwork(isShow)
    }

    func setShowSmartAccountSetting(_ isShow: Bool) {
        ParticleWalletGUI.setShowSmartAccountSetting(isShow)
    }

    func setShowManageWallet(_ isShow: Bool) {
        ParticleWalletGUI.setShowManageWallet(isShow)
    }

    func setSupportChain(_ json: String?) {
        guard let json = json else { return }
        let chains = JSON(parseJSON: json).arrayValue.compactMap {
            let chainId = $0["chain_id"].intValue
            let chainName = $0["chain_name"].stringValue.lowercased()
            let chainType: ChainType = chainName == "solana" ? .solana : .evm
            return ParticleNetwork.searchChainInfo(by: chainId, chainType: chainType)?.chain
        }
        ParticleWalletGUI.setSupportChain(chains)
    }

    func setPayDisabled(_ disabled: Bool) {
        ParticleWalletGUI.setPayDisabled(disabled)
    }

    func getPayDisabled(flutterResult: @escaping FlutterResult) {
        flutterResult(ParticleWalletGUI.getPayDisabled())
    }

    func setSwapDisabled(_ disabled: Bool) {
        ParticleWalletGUI.setSwapDisabled(disabled)
    }

    func getSwapDisabled(flutterResult: @escaping FlutterResult) {
        flutterResult(ParticleWalletGUI.getSwapDisabled())
    }

    func switchWallet(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else {
            callback(getErrorJson("json is nil"))
            return
        }

        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue

        if let walletType = map2WalletType(from: walletTypeString) {
            let result = ParticleWalletGUI.switchWallet(walletType: walletType, publicAddress: publicAddress)
            callback(result)
        } else {
            print("walletType \(walletTypeString) is not existed")
            callback(false)
        }
    }

    private func getLanguage(from json: String) -> Language? {
        /*
         en,
         zh_hans,
         zh_hant,
         ja,
         ko
         */
        var language: Language?
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

    func setSupportDappBrowser(_ enable: Bool) {
        ParticleWalletGUI.setSupportDappBrowser(enable)
    }

    func setShowLanguageSetting(_ isShow: Bool) {
        ParticleWalletGUI.setShowLanguageSetting(isShow)
    }

    func setShowAppearanceSetting(_ isShow: Bool) {
        ParticleWalletGUI.setShowAppearanceSetting(isShow)
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

    func setSupportWalletConnect(_ enable: Bool) {
        ParticleWalletGUI.setSupportWalletConnect(enable)
    }

    func initializeWalletMetaData(_ json: String?) {
        guard let json = json else {
            return
        }

        let data = JSON(parseJSON: json)

        let walletName = data["name"].stringValue
        let walletIconString = data["icon"].stringValue
        let walletUrlString = data["url"].stringValue
        let walletDescription = data["description"].stringValue

        let walletIconUrl = URL(string: walletIconString) != nil ? URL(string: walletIconString)! : URL(string: "https://connect.particle.network/icons/512.png")!

        let walletUrl = URL(string: walletUrlString) != nil ? URL(string: walletUrlString)! : URL(string: "https://connect.particle.network")!

        ParticleWalletConnect.initialize(.init(name: walletName, icon: walletIconUrl, url: walletUrl, description: walletDescription))
    }

    func setWalletConnectV2ProjectId(_ json: String?) {
        guard let json = json else {
            return
        }
        ParticleWalletConnect.setWalletConnectV2ProjectId(json)
    }

    func setCustomWalletName(_ json: String?) {
        guard let json = json else {
            return
        }

        let data = JSON(parseJSON: json)

        let name = data["name"].stringValue
        let icon = data["icon"].stringValue

        ConnectManager.setCustomWalletName(walletType: .particle, name: .init(name: name, icon: icon))
    }

    func setCustomLocalizable(_ json: String?) {
        guard let json = json else {
            return
        }

        let data = JSON(parseJSON: json).dictionaryValue

        var localizables: [Language: [String: String]] = [:]

        for (key, value) in data {
            let language = self.getLanguage(from: key.lowercased())
            if language == nil {
                continue
            }

            let itemLocalizables = value.dictionaryValue.mapValues { json in
                json.stringValue
            }
            localizables[language!] = itemLocalizables
        }

        ParticleWalletGUI.setCustomLocalizable(localizables)
    }
}

extension ParticleWalletPlugin {
    private func subscribeAndCallback<T: Codable>(observable: Single<T>, callback: @escaping ParticleCallback) {
        observable.subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback(json)
            case .success(let signedMessage):
                let statusModel = FlutterStatusModel(status: true, data: signedMessage)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback(json)
            }
        }.disposed(by: self.bag)
    }
}

extension ParticleWalletPlugin {
    private func getErrorJson(_ message: String) -> String {
        let response = FlutterResponseError(code: nil, message: message, data: nil)
        let statusModel = FlutterStatusModel(status: false, data: response)
        let data1 = try! JSONEncoder().encode(statusModel)
        guard let json = String(data: data1, encoding: .utf8) else { return "" }
        return json
    }
}
