//
//  ParticleWalletPlugin.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

import Flutter
import Foundation
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
        case showTestNetwork
        case showManageWallet
        case supportChain
        case enablePay
        case getEnablePay
        case enableSwap
        case getEnableSwap
        case switchWallet
        case setLanguage
        case setInterfaceStyle
        case supportWalletConnect
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
        case .setInterfaceStyle:
            self.setInterfaceStyle(json as? String)
        case .supportWalletConnect:
            self.supportWalletConnect((json as? Bool) ?? false)
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
        let toAddress = data["receiver_address"].stringValue
        let tokenId = data["token_id"].stringValue
        let config = NFTSendConfig(address: address, toAddress: toAddress.isEmpty ? nil : toAddress, tokenId: tokenId)
        PNRouter.navigatroNFTSend(nftSendConfig: config)
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
        PNRouter.navigatorPay()
    }

    func navigatorBuyCrypto(_ json: String?) {
        guard let json = json else { return }
        let data = JSON(parseJSON: json)
        let walletAddress = data["wallet_address"].string
        let networkString = data["network"].stringValue.lowercased()
        var network: OpenBuyNetwork?
        /*
         Solana,
         Ethereum,
         BinanceSmartChain,
         Avalanche,
         Polygon,
         */
        if networkString == "solana" {
            network = .solana
        } else if networkString == "ethereum" {
            network = .ethereum
        } else if networkString == "binancesmartchain" {
            network = .binanceSmartChain
        } else if networkString == "avalanche" {
            network = .avalanche
        } else if networkString == "polygon" {
            network = .polygon
        } else {
            network = nil
        }
        let fiatCoin = data["fiat_coin"].string
        let fiatAmt = data["fiat_amt"].int
        let cryptoCoin = data["crypto_coin"].string
            
        PNRouter.navigatorBuy(walletAddress: walletAddress, network: network, cryptoCoin: cryptoCoin, fiatCoin: fiatCoin, fiatAmt: fiatAmt)
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

    func showTestNetwork(_ show: Bool) {
        ParticleWalletGUI.showTestNetwork(show)
    }

    func showManageWallet(_ show: Bool) {
        ParticleWalletGUI.showManageWallet(show)
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
            
            let statusModel = FlutterStatusModel(status: true, data: result == true ? "success" : "failed")
            
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
        } else {
            print("walletType \(walletTypeString) is not existed")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not existed", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
        }
    }

    func setLanguage(_ json: String?) {
        guard let json = json else { return }
        
        /**
         SYSTEM,
         EN,
         ZH_HANS,
         */
        if json.lowercased() == "system" {
            ParticleWalletGUI.setLanguage(Language.unspecified)
        } else if json.lowercased() == "en" {
            ParticleWalletGUI.setLanguage(Language.en)
        } else if json.lowercased() == "zh_hans" {
            ParticleWalletGUI.setLanguage(Language.zh_Hans)
        }
    }

    func setInterfaceStyle(_ json: String?) {
        guard let json = json else { return }
        /**
         SYSTEM,
         LIGHT,
         DARK,
         */
        if json.lowercased() == "system" {
            ParticleWalletGUI.setInterfaceStyle(UIUserInterfaceStyle.unspecified)
        } else if json.lowercased() == "light" {
            ParticleWalletGUI.setInterfaceStyle(UIUserInterfaceStyle.light)
        } else if json.lowercased() == "dark" {
            ParticleWalletGUI.setInterfaceStyle(UIUserInterfaceStyle.dark)
        }
    }

    func supportWalletConnect(_ enable: Bool) {
        ParticleWalletGUI.supportWalletConnect(enable)
    }
}
