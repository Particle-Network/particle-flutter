//
//  ShareWallet.swift
//  particle_wallet
//
//  Created by link on 16/08/2024.
//

import ConnectCommon
import Foundation
import ParticleConnect
import ParticleNetworkBase
import ParticleNetworkChains
import ParticleWalletConnect
import ParticleWalletGUI
import RxSwift
import SwiftyJSON

typealias ShareCallback = (Any) -> Void

class ShareWallet {
    static let shared: ShareWallet = .init()
    let bag = DisposeBag()

    func navigatorWallet(_ display: Int) {
        if display != 0 {
            PNRouter.navigatorWallet(display: .nft)
        } else {
            PNRouter.navigatorWallet(display: .token)
        }
    }

    func navigatorTokenReceive(_ json: String) {
        let tokenAddress = json
        PNRouter.navigatorTokenReceive(tokenReceiveConfig: tokenAddress.isEmpty ? nil : TokenReceiveConfig(tokenAddress: json))
    }

    func navigatorTokenSend(_ json: String) {
        let data = JSON(parseJSON: json)
        let tokenAddress = data["token_address"].stringValue
        let toAddress = data["to_address"].stringValue
        let amount = data["amount"].stringValue
        let config = TokenSendConfig(tokenAddress: tokenAddress.isEmpty ? nil : amount, toAddress: toAddress.isEmpty ? nil : toAddress, amountString: amount.isEmpty ? nil : amount)

        PNRouter.navigatorTokenSend(tokenSendConfig: config)
    }

    func navigatorTokenTransactionRecords(_ json: String) {
        let tokenAddress = json

        PNRouter.navigatorTokenTransactionRecords(tokenTransactionRecordsConfig: tokenAddress.isEmpty ? nil : TokenTransactionRecordsConfig(tokenAddress: json))
    }

    func navigatorNFTSend(_ json: String) {
        let data = JSON(parseJSON: json)
        let address = data["mint"].stringValue
        let tokenId = data["token_id"].stringValue
        let toAddress = data["receiver_address"].stringValue
        let amount = data["amount"].stringValue
        let config = NFTSendConfig(address: address, toAddress: toAddress.isEmpty ? nil : toAddress, tokenId: tokenId, amountString: amount.isEmpty ? nil : amount)
        PNRouter.navigatorNFTSend(nftSendConfig: config)
    }

    func navigatorNFTDetails(_ json: String) {
        let data = JSON(parseJSON: json)
        let address = data["mint"].stringValue
        let tokenId = data["token_id"].stringValue
        let config = NFTDetailsConfig(address: address, tokenId: tokenId)
        PNRouter.navigatorNFTDetails(nftDetailsConfig: config)
    }

    func navigatorBuyCrypto(_ json: String) {
        let data = JSON(parseJSON: json)
        let walletAddress = data["wallet_address"].string
        let chainId = data["chain_info"]["chain_id"].intValue
        let chainName = data["chain_info"]["chain_name"].stringValue.lowercased()
        let chainType: ChainType = chainName == "solana" ? .solana : .evm

        let chainInfo = ParticleNetwork.searchChainInfo(by: chainId, chainType: chainType) ?? ParticleNetwork.getChainInfo()

        let fiatCoin = data["fiat_coin"].string
        let fiatAmt = data["fiat_amt"].int
        let cryptoCoin = data["crypto_coin"].string
        let fixCryptoCoin = data["fix_crypto_coin"].boolValue
        let fixFiatAmt = data["fix_fiat_amt"].boolValue
        let fixFiatCoin = data["fix_fiat_coin"].boolValue
        let theme = data["theme"].stringValue.lowercased()
        let language = self.getLanguage(from: data["language"].stringValue.lowercased())

        var buyConfig = BuyCryptoConfig()
        buyConfig.network = chainInfo
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

    func navigatorSwap(_ json: String) {
        let data = JSON(parseJSON: json)
        let fromTokenAddress = data["from_token_address"].string
        let toTokenAddress = data["to_token_address"].string
        let amount = data["amount"].string
        let config = SwapConfig(fromTokenAddress: fromTokenAddress, toTokenAddress: toTokenAddress, fromTokenAmountString: amount)

        PNRouter.navigatorSwap(swapConfig: config)
    }

    func navigatorDappBrowser(_ json: String) {
        let data = JSON(parseJSON: json)
        let urlStr = data["url"].stringValue
        if let url = URL(string: urlStr) {
            PNRouter.navigatorDappBrowser(url: url)
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

    func setSupportChain(_ json: String) {
        let chains = JSON(parseJSON: json).arrayValue.compactMap {
            let chainId = $0["chain_id"].intValue
            let chainName = $0["chain_name"].stringValue.lowercased()
            let chainType: ChainType = chainName == "solana" ? .solana : .evm
            return ParticleNetwork.searchChainInfo(by: chainId, chainType: chainType)
        }
        ParticleWalletGUI.setSupportChain(Set(chains))
    }

    func setPayDisabled(_ disabled: Bool) {
        ParticleWalletGUI.setPayDisabled(disabled)
    }

    func getPayDisabled() -> Bool {
        return ParticleWalletGUI.getPayDisabled()
    }

    func setSwapDisabled(_ disabled: Bool) {
        ParticleWalletGUI.setSwapDisabled(disabled)
    }

    func getSwapDisabled() -> Bool {
        return ParticleWalletGUI.getSwapDisabled()
    }
    
    func setBridgeDisabled(_ disabled: Bool) {
        ParticleWalletGUI.setBridgeDisabled(disabled)
    }

    func getBridgeDisabled() -> Bool {
        return ParticleWalletGUI.getBridgeDisabled()
    }

    func switchWallet(_ json: String) -> Bool {
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        if let walletType = WalletType.fromString(walletTypeString) {
            let result = ParticleWalletGUI.switchWallet(walletType: walletType, publicAddress: publicAddress)
            return result
        } else {
            print("walletType \(walletTypeString) is not existed")
            return false
        }
    }

    private func getLanguage(from json: String) -> Language? {
        let languageString = json.lowercased()
        /*
         en,
         zh_hans, zh_cn
         zh_hant, zh_tw
         ja,
         ko
         */

        var language: Language?
        switch languageString {
        case "en":
            language = .en
        case "ja":
            language = .ja
        case "ko":
            language = .ko
        case "zh_hans", "zh_cn":
            language = .zh_Hans
        case "zh_hant", "zh_tw":
            language = .zh_Hant
        default:
            language = nil
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

    func setDisplayTokenAddresses(_ json: String) {
        let data = JSON(parseJSON: json)
        let tokenAddresses = data.arrayValue.map {
            $0.stringValue
        }
        ParticleWalletGUI.setDisplayTokenAddresses(tokenAddresses)
    }

    func setDisplayNFTContractAddresses(_ json: String) {
        let data = JSON(parseJSON: json)
        let nftContractAddresses = data.arrayValue.map {
            $0.stringValue
        }
        ParticleWalletGUI.setDisplayNFTContractAddresses(nftContractAddresses)
    }

    func setPriorityTokenAddresses(_ json: String) {
        let data = JSON(parseJSON: json)
        let tokenAddresses = data.arrayValue.map {
            $0.stringValue
        }
        ParticleWalletGUI.setPriorityTokenAddresses(tokenAddresses)
    }

    func setPriorityNFTContractAddresses(_ json: String) {
        let data = JSON(parseJSON: json)
        let nftContractAddresses = data.arrayValue.map {
            $0.stringValue
        }
        ParticleWalletGUI.setPriorityNFTContractAddresses(nftContractAddresses)
    }

    func setSupportWalletConnect(_ enable: Bool) {
        ParticleWalletGUI.setSupportWalletConnect(enable)
    }

    func initializeWalletMetaData(_ json: String) {
        let data = JSON(parseJSON: json)

        let walletName = data["name"].stringValue
        let walletIconString = data["icon"].stringValue
        let walletUrlString = data["url"].stringValue
        let walletDescription = data["description"].stringValue

        let walletConnectV2ProjectId = data["walletConnectProjectId"].stringValue

        let walletIconUrl = URL(string: walletIconString) != nil ? URL(string: walletIconString)! : URL(string: "https://connect.particle.network/icons/512.png")!

        let walletUrl = URL(string: walletUrlString) != nil ? URL(string: walletUrlString)! : URL(string: "https://connect.particle.network")!

        ParticleWalletConnect.initialize(.init(name: walletName, icon: walletIconUrl, url: walletUrl, description: walletDescription, redirectUniversalLink: nil))
        ParticleWalletConnect.setWalletConnectV2ProjectId(walletConnectV2ProjectId)
        ParticleWalletGUI.setAdapters(ParticleConnect.getAllAdapters())
    }

    func setCustomWalletName(_ json: String) {
        let data = JSON(parseJSON: json)

        let name = data["name"].stringValue
        let icon = data["icon"].stringValue

        ConnectManager.setCustomWalletName(walletType: .authCore, name: .init(name: name, icon: icon))
    }

    func setCustomLocalizable(_ json: String) {
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

extension ShareWallet {
    private func subscribeAndCallback<T: Codable>(observable: Single<T>, callback: @escaping ShareCallback) {
        observable.subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = responseFromError(error)
                let statusModel = PNStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback(json)
            case .success(let signedMessage):
                let statusModel = PNStatusModel(status: true, data: signedMessage)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback(json)
            }
        }.disposed(by: self.bag)
    }
}
