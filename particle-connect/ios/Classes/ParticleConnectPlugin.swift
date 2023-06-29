//
//  ParticleConnectPlugin.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

import ConnectCommon
import Flutter
import Foundation
import ParticleAuthService
import ParticleConnect
import ParticleNetworkBase
import RxSwift
import SwiftyJSON

#if canImport(ConnectEVMAdapter)
import ConnectEVMAdapter
#endif

#if canImport(ConnectSolanaAdapter)
import ConnectSolanaAdapter
#endif

#if canImport(ConnectPhantomAdapter)
import ConnectPhantomAdapter
#endif

#if canImport(ConnectWalletConnectAdapter)
import ConnectWalletConnectAdapter
#endif

public class ParticleConnectPlugin: NSObject, FlutterPlugin {
    let bag = DisposeBag()
    
    var eventSink: FlutterEventSink?
    
    var latestPublicAddress: String?
    var latestWalletType: WalletType?
    
    public enum Method: String {
        case initialize
        case getAccounts
        case connect
        case disconnect
        case isConnected
        case signMessage
        case signTransaction
        case signAllTransactions
        case signAndSendTransaction
        case signTypedData
        case login
        case verify
        case importPrivateKey
        case importMnemonic
        case exportPrivateKey
        case switchEthereumChain
        case addEthereumChain
        case walletReadyState
        case reconnectIfNeeded
        case connectWalletConnect
        case batchSendTransactions
        case setWalletConnectV2ProjectId
        case setWalletConnectV2SupportChainInfos
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "connect_bridge", binaryMessenger: registrar.messenger())
        
        let instance = ParticleConnectPlugin()
        
        let eventChannel = FlutterEventChannel(name: "connect_event_bridge", binaryMessenger: registrar.messenger())
        
        eventChannel.setStreamHandler(instance)
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = Method(rawValue: call.method) else {
            result(FlutterMethodNotImplemented)
            return
        }
            
        let json = call.arguments
            
        switch method {
        case .initialize:
            self.initialize(json as? String)
        case .getAccounts:
            self.getAccounts(json as? String, flutterResult: result)
        case .connect:
            self.connect(json as? String, flutterResult: result)
        case .disconnect:
            self.disconnect(json as? String, flutterResult: result)
        case .isConnected:
            self.isConnected(json as? String, flutterResult: result)
        case .signMessage:
            self.signMessage(json as? String, flutterResult: result)
        case .signTransaction:
            self.signTransaction(json as? String, flutterResult: result)
        case .signAllTransactions:
            self.signAllTransactions(json as? String, flutterResult: result)
        case .signAndSendTransaction:
            self.signAndSendTransaction(json as? String, flutterResult: result)
        case .signTypedData:
            self.signTypedData(json as? String, flutterResult: result)
        case .login:
            self.login(json as? String, flutterResult: result)
        case .verify:
            self.verify(json as? String, flutterResult: result)
        case .importPrivateKey:
            self.importPrivateKey(json as? String, flutterResult: result)
        case .importMnemonic:
            self.importMnemonic(json as? String, flutterResult: result)
        case .exportPrivateKey:
            self.exportPrivateKey(json as? String, flutterResult: result)
        case .switchEthereumChain:
            self.switchEthereumChain(json as? String, flutterResult: result)
        case .addEthereumChain:
            self.addEthereumChain(json as? String, flutterResult: result)
        case .walletReadyState:
            self.walletReadyState(json as? String, flutterResult: result)
        case .reconnectIfNeeded:
            self.reconnectIfNeeded(json as? String)
        case .connectWalletConnect:
            self.connectWalletConnect(flutterResult: result)
        case .batchSendTransactions:
            self.batchSendTransactions(json as? String, flutterResult: result)
        case .setWalletConnectV2ProjectId:
            self.setWalletConnectV2ProjectId(json as? String)
        case .setWalletConnectV2SupportChainInfos:
            self.setWalletConnectV2SupportChainInfos(json as? String)
        }
    }
}

// MARK: -  Methods

extension ParticleConnectPlugin {
    func initialize(_ json: String?) {
        guard let json = json else {
            return
        }
        
        let data = JSON(parseJSON: json)
        let chainName = data["chain_name"].stringValue.lowercased()
        let chainId = data["chain_id"].intValue
        
        guard let chainInfo = ParticleNetwork.searchChainInfo(by: chainId) else {
            return print("initialize error, can't find right chain for \(chainName), chainId \(chainId)")
        }
        let env = data["env"].stringValue.lowercased()
        var devEnv: ParticleNetwork.DevEnvironment = .production
        // DEV, STAGING, PRODUCTION
        if env == "dev" {
            devEnv = .debug
        } else if env == "staging" {
            devEnv = .staging
        } else if env == "production" {
            devEnv = .production
        }
        
        let dAppName = data["metadata"]["name"].stringValue
        let dAppIconString = data["metadata"]["icon"].stringValue
        let dAppUrlString = data["metadata"]["url"].stringValue
        let dappDescription = data["metadata"]["description"].stringValue
        let dAppIconUrl = URL(string: dAppIconString) != nil ? URL(string: dAppIconString)! : URL(string: "https://connect.particle.network/icons/512.png")!
        
        let dAppUrl = URL(string: dAppUrlString) != nil ? URL(string: dAppUrlString)! : URL(string: "https://connect.particle.network")!
        
        let dAppData = DAppMetaData(name: dAppName, icon: dAppIconUrl, url: dAppUrl, description: dappDescription)
        
        var adapters: [ConnectAdapter] = [ParticleConnectAdapter()]
#if canImport(ConnectEVMAdapter)
        let evmRpcUrl = data["rpc_url"]["evm_url"].stringValue
        if evmRpcUrl.isEmpty {
            adapters.append(EVMConnectAdapter())
        } else {
            adapters.append(EVMConnectAdapter(rpcUrl: evmRpcUrl))
        }
#endif
        
#if canImport(ConnectSolanaAdapter)
        let solanaRpcUrl = data["rpc_url"]["sol_url"].stringValue
        if solanaRpcUrl.isEmpty {
            adapters.append(SolanaConnectAdapter())
        } else {
            adapters.append(SolanaConnectAdapter(rpcUrl: solanaRpcUrl))
        }
#endif
        
#if canImport(ConnectPhantomAdapter)
        adapters.append(PhantomConnectAdapter())
#endif
        
#if canImport(ConnectWalletConnectAdapter)
        adapters.append(MetaMaskConnectAdapter())
        adapters.append(RainbowConnectAdapter())
        adapters.append(BitkeepConnectAdapter())
        adapters.append(ImtokenConnectAdapter())
        adapters.append(TrustConnectAdapter())
        adapters.append(WalletConnectAdapter())
        
        let moreAdapterClasses: [WalletConnectAdapter.Type] =
            [ZerionConnectAdapter.self,
             MathConnectAdapter.self,
             OmniConnectAdapter.self,
             Inch1ConnectAdapter.self,
             ZengoConnectAdapter.self,
             AlphaConnectAdapter.self,
             BitpieConnectAdapter.self]

        adapters.append(contentsOf: moreAdapterClasses.map {
            $0.init()
        })
        
#endif
        ParticleConnect.initialize(env: devEnv, chainInfo: chainInfo, dAppData: dAppData) {
            adapters
        }
    }
    
    func setWalletConnectV2ProjectId(_ json: String?) {
        guard let json = json else {
            return
        }
        
        ParticleConnect.setWalletConnectV2ProjectId(json)
    }
    
    func setWalletConnectV2SupportChainInfos(_ json: String?) {
        guard let json = json else {
            return
        }
        
        let chainInfos = JSON(parseJSON: json).arrayValue.map {
            $0["chain_id"].intValue
        }.compactMap {
            ParticleNetwork.searchChainInfo(by: $0)
        }
        
        ParticleConnect.setWalletConnectV2SupportChainInfos(chainInfos)
    }
    
    func getAccounts(_ json: String?, flutterResult: FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let walletTypeString = json
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed")
            flutterResult(FlutterError(code: "", message: "walletType \(walletTypeString) is not existed", details: nil))
            return
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            flutterResult(FlutterError(code: "", message: "adapter for \(walletTypeString) is not init", details: nil))
            return
        }
        
        let accounts = adapter.getAccounts()
        let statusModel = FlutterStatusModel(status: true, data: accounts)
        let data = try! JSONEncoder().encode(statusModel)
        let jsonString = String(data: data, encoding: .utf8) ?? ""
        flutterResult(jsonString)
    }
    
    func connect(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let data = JSON(parseJSON: json)
        
        let walletTypeString = data["wallet_type"].stringValue
        let configJson = data["particle_connect_config"]
        
        var connectConfig: ParticleConnectConfig?
        
        if !configJson.isEmpty {
            let loginType = LoginType(rawValue: configJson["login_type"].stringValue.lowercased()) ?? .email
            var supportAuthTypeArray: [SupportAuthType] = []
            
            let array = configJson["support_auth_type_values"].arrayValue.map {
                $0.stringValue.lowercased()
            }
            if array.contains("all") {
                supportAuthTypeArray = [.all]
            } else {
                array.forEach {
                    if $0 == "email" {
                        supportAuthTypeArray.append(.email)
                    } else if $0 == "phone" {
                        supportAuthTypeArray.append(.phone)
                    } else if $0 == "apple" {
                        supportAuthTypeArray.append(.apple)
                    } else if $0 == "google" {
                        supportAuthTypeArray.append(.google)
                    } else if $0 == "facebook" {
                        supportAuthTypeArray.append(.facebook)
                    } else if $0 == "github" {
                        supportAuthTypeArray.append(.github)
                    } else if $0 == "twitch" {
                        supportAuthTypeArray.append(.twitch)
                    } else if $0 == "microsoft" {
                        supportAuthTypeArray.append(.microsoft)
                    } else if $0 == "linkedin" {
                        supportAuthTypeArray.append(.linkedin)
                    } else if $0 == "discord" {
                        supportAuthTypeArray.append(.discord)
                    } else if $0 == "twitter" {
                        supportAuthTypeArray.append(.twitter)
                    }
                }
            }
            
            var account = configJson["account"].string
            
            if account != nil, account!.isEmpty {
                account = nil
            }
            
            let loginFormMode = configJson["login_form_mode"].boolValue
            let socialLoginPromptString = configJson["social_login_prompt"].stringValue.lowercased()
            let socialLoginPrompt: SocialLoginPrompt? = SocialLoginPrompt(rawValue: socialLoginPromptString)
            
            connectConfig = ParticleConnectConfig(loginType: loginType, supportAuthType: supportAuthTypeArray, loginFormMode: loginFormMode, phoneOrEmailAccount: account, socialLoginPrompt: socialLoginPrompt)
        }
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not existed", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            let response = FlutterResponseError(code: nil, message: "adapter for \(walletTypeString) is not init", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        guard let vc = UIViewController.topMost else {
            return
        }
        
        var observable: Single<Account?>
        if walletType == .walletConnect {
            observable = (adapter as! WalletConnectAdapter).connectWithQrCode(from: vc)
        } else if walletType == .particle {
            observable = adapter.connect(connectConfig)
        } else {
            observable = adapter.connect(ConnectConfig.none)
        }
        
        observable.subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            case .success(let account):
                guard let account = account else { return }
                let statusModel = FlutterStatusModel(status: true, data: account)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            }
        }.disposed(by: self.bag)
    }
    
    func disconnect(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed ")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not existed", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            let response = FlutterResponseError(code: nil, message: "adapter for \(walletTypeString) is not init", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        adapter.disconnect(publicAddress: publicAddress).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            case .success(let success):
                let statusModel = FlutterStatusModel(status: true, data: success)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            }
        }.disposed(by: self.bag)
    }
    
    func isConnected(_ json: String?, flutterResult: FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed ")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not existed", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            let response = FlutterResponseError(code: nil, message: "adapter for \(walletTypeString) is not init", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        flutterResult(adapter.isConnected(publicAddress: publicAddress))
    }
    
    func signAndSendTransaction(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        let transaction = data["transaction"].stringValue
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed ")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not existed", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        let mode = data["fee_mode"]["option"].stringValue
        var feeMode: Biconomy.FeeMode = .auto
        if mode == "auto" {
            feeMode = .auto
        } else if mode == "gasless" {
            feeMode = .gasless
        } else if mode == "custom" {
            let feeQuoteJson = JSON(data["fee_mode"]["fee_quote"].dictionaryValue)
            let feeQuote = Biconomy.FeeQuote(json: feeQuoteJson)
            feeMode = .custom(feeQuote)
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            let response = FlutterResponseError(code: nil, message: "adapter for \(walletTypeString) is not init", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        adapter.signAndSendTransaction(publicAddress: publicAddress, transaction: transaction, feeMode: feeMode).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            case .success(let signature):
                let statusModel = FlutterStatusModel(status: true, data: signature)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            }
        }.disposed(by: self.bag)
    }
    
    func batchSendTransactions(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let data = JSON(parseJSON: json)
        let transactions = data["transactions"].arrayValue.map {
            $0.stringValue
        }
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed ")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not existed", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        self.latestPublicAddress = publicAddress
        self.latestWalletType = walletType
        
        let mode = data["fee_mode"]["option"].stringValue
        var feeMode: Biconomy.FeeMode = .auto
        if mode == "auto" {
            feeMode = .auto
        } else if mode == "gasless" {
            feeMode = .gasless
        } else if mode == "custom" {
            let feeQuoteJson = JSON(data["fee_mode"]["fee_quote"].dictionaryValue)
            let feeQuote = Biconomy.FeeQuote(json: feeQuoteJson)
            feeMode = .custom(feeQuote)
        }
        
        guard let biconomy = ParticleNetwork.getBiconomyService() else {
            flutterResult(FlutterError(code: "", message: "biconomy is not init", details: nil))
            return
        }
        
        guard biconomy.isBiconomyModeEnable() else {
            flutterResult(FlutterError(code: "", message: "biconomy is not enable", details: nil))
            return
        }
        
        biconomy.quickSendTransactions(transactions, feeMode: feeMode, messageSigner: self).subscribe {
            [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    let response = self.ResponseFromError(error)
                    let statusModel = FlutterStatusModel(status: false, data: response)
                    let data = try! JSONEncoder().encode(statusModel)
                    guard let json = String(data: data, encoding: .utf8) else { return }
                    flutterResult(json)
                case .success(let signature):
                    let statusModel = FlutterStatusModel(status: true, data: signature)
                    let data = try! JSONEncoder().encode(statusModel)
                    guard let json = String(data: data, encoding: .utf8) else { return }
                    flutterResult(json)
                }
        }.disposed(by: self.bag)
    }
    
    func signTransaction(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        let transaction = data["transaction"].stringValue
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed ")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not existed", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            let response = FlutterResponseError(code: nil, message: "adapter for \(walletTypeString) is not init", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        adapter.signTransaction(publicAddress: publicAddress, transaction: transaction).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            case .success(let signed):
                let statusModel = FlutterStatusModel(status: true, data: signed)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            }
        }.disposed(by: self.bag)
    }
    
    func signAllTransactions(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        let transactions = data["transactions"].arrayValue.map {
            $0.stringValue
        }
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed ")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not existed", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            let response = FlutterResponseError(code: nil, message: "adapter for \(walletTypeString) is not init", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        adapter.signAllTransactions(publicAddress: publicAddress, transactions: transactions).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            case .success(let signed):
                let statusModel = FlutterStatusModel(status: true, data: signed)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            }
        }.disposed(by: self.bag)
    }
    
    func signMessage(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        var message = data["message"].stringValue
        // solana message should encoded in base58
        if ConnectManager.getChainType() == .solana {
            message = Base58.encode(message.data(using: .utf8)!)
        }
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed ")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not existed", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            let response = FlutterResponseError(code: nil, message: "adapter for \(walletTypeString) is not init", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        adapter.signMessage(publicAddress: publicAddress, message: message).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            case .success(let signed):
                let statusModel = FlutterStatusModel(status: true, data: signed)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            }
        }.disposed(by: self.bag)
    }
    
    func signTypedData(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        let message = data["message"].stringValue
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed ")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not existed", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            let response = FlutterResponseError(code: nil, message: "adapter for \(walletTypeString) is not init", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        adapter.signTypedData(publicAddress: publicAddress, data: message).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            case .success(let signed):
                let statusModel = FlutterStatusModel(status: true, data: signed)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            }
        }.disposed(by: self.bag)
    }
    
    func importPrivateKey(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let privateKey = data["private_key"].stringValue
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed ")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not existed", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            let response = FlutterResponseError(code: nil, message: "adapter for \(walletTypeString) is not init", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        guard walletType == WalletType.evmPrivateKey || walletType == WalletType.solanaPrivateKey else {
            print("walletType \(walletTypeString) is not support import from private key")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not support import from private key", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            
            return
        }
        
        (adapter as! LocalAdapter).importWalletFromPrivateKey(privateKey).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            case .success(let account):
                guard let account = account else { return }
                let statusModel = FlutterStatusModel(status: true, data: account)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            }
        }.disposed(by: self.bag)
    }
    
    func importMnemonic(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let mnemonic = data["mnemonic"].stringValue
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed ")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not existed", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            let response = FlutterResponseError(code: nil, message: "adapter for \(walletTypeString) is not init", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        guard walletType == WalletType.evmPrivateKey || walletType == WalletType.solanaPrivateKey else {
            print("walletType \(walletTypeString) is not support import from private key")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not support import from private key", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            
            return
        }
        
        (adapter as! LocalAdapter).importWalletFromMnemonic(mnemonic).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            case .success(let account):
                guard let account = account else { return }
                let statusModel = FlutterStatusModel(status: true, data: account)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            }
        }.disposed(by: self.bag)
    }
    
    func exportPrivateKey(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed ")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not existed", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            let response = FlutterResponseError(code: nil, message: "adapter for \(walletTypeString) is not init", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        guard walletType == WalletType.evmPrivateKey || walletType == WalletType.solanaPrivateKey else {
            print("walletType \(walletTypeString) is not support import from private key")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not support import from private key", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            
            return
        }
        
        (adapter as! LocalAdapter).exportWalletPrivateKey(publicAddress: publicAddress).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            case .success(let privateKey):
                let statusModel = FlutterStatusModel(status: true, data: privateKey)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            }
        }.disposed(by: self.bag)
    }
    
    func login(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        let domain = data["domain"].stringValue
        let address = publicAddress
        guard let uri = URL(string: data["uri"].stringValue) else { return }
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed ")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not existed", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            let response = FlutterResponseError(code: nil, message: "adapter for \(walletTypeString) is not init", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        let siwe = try! SiweMessage(domain: domain, address: address, uri: uri)
        
        adapter.login(config: siwe, publicAddress: publicAddress).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            case .success(let (sourceMessage, signedMessage)):
                let result = FlutterConnectLoginResult(message: sourceMessage, signature: signedMessage)
                let statusModel = FlutterStatusModel(status: true, data: result)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            }
        }.disposed(by: self.bag)
    }
    
    func verify(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let message = data["message"].stringValue
        var signature = data["signature"].stringValue
        
        if ConnectManager.getChainType() == .solana {
            signature = Base58.encode(Data(base64Encoded: signature)!)
        }
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed ")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not existed", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            let response = FlutterResponseError(code: nil, message: "adapter for \(walletTypeString) is not init", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        let siwe = try! SiweMessage(message)
        
        adapter.verify(message: siwe, against: signature).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            case .success(let flag):
                let statusModel = FlutterStatusModel(status: true, data: flag)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            }
        }.disposed(by: self.bag)
    }
    
    func switchEthereumChain(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        let chainId = data["chain_id"].intValue

        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed ")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not existed", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            let response = FlutterResponseError(code: nil, message: "adapter for \(walletTypeString) is not init", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        adapter.switchEthereumChain(publicAddress: publicAddress, chainId: chainId).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            case .success(let flag):
                let statusModel = FlutterStatusModel(status: true, data: flag)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            }
        }.disposed(by: self.bag)
    }
    
    func addEthereumChain(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        let chainId = data["chain_id"].intValue

        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed ")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not existed", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            let response = FlutterResponseError(code: nil, message: "adapter for \(walletTypeString) is not init", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        adapter.addEthereumChain(publicAddress: publicAddress, chainId: chainId, chainName: nil, nativeCurrency: nil, rpcUrl: nil, blockExplorerUrl: nil).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            case .success(let flag):
                let statusModel = FlutterStatusModel(status: true, data: flag)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            }
        }.disposed(by: self.bag)
    }
    
    func walletReadyState(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue

        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed ")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not existed", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            let response = FlutterResponseError(code: nil, message: "adapter for \(walletTypeString) is not init", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            flutterResult(json)
            return
        }
        
        var str: String
        switch adapter.readyState {
        case .installed:
            str = "installed"
        case .notDetected:
            str = "notDetected"
        case .loadable:
            str = "loadable"
        case .unsupported:
            str = "unsupported"
        case .undetectable:
            str = "undetectable"
        @unknown default:
            str = "undetectable"
        }
        
        flutterResult(str)
    }
    
    func reconnectIfNeeded(_ json: String?) {
        guard let json = json else {
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed ")
            return
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            return
        }
        
        (adapter as? WalletConnectAdapter)?.reconnectIfNeeded(publicAddress: publicAddress)
    }
    
    func connectWalletConnect(flutterResult: @escaping FlutterResult) {
        guard let adapter = map2ConnectAdapter(from: .walletConnect) else {
            print("adapter for walletConnect is not init")
            return
        }
        Task {
            let (uri, observable) = await (adapter as! WalletConnectAdapter).getConnectionUrl()
            
            observable.subscribe { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    let response = self.ResponseFromError(error)
                    let statusModel = FlutterStatusModel(status: false, data: response)
                    let data = try! JSONEncoder().encode(statusModel)
                    guard let json = String(data: data, encoding: .utf8) else { return }
                    flutterResult(json)
                case .success(let account):
                    guard let account = account else { return }
                    let statusModel = FlutterStatusModel(status: true, data: account)
                    let data = try! JSONEncoder().encode(statusModel)
                    guard let json = String(data: data, encoding: .utf8) else { return }
                    flutterResult(json)
                }
            }.disposed(by: self.bag)
            
            self.eventSink?(uri)
        }
       
        
       
    }
}

extension ParticleConnectPlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}

extension ParticleConnectPlugin: MessageSigner {
    public func signTypedData(_ message: String) -> RxSwift.Single<String> {
        guard let walletType = self.latestWalletType else {
            print("walletType is nil")
            return .error(ParticleNetwork.ResponseError(code: nil, message: "walletType is nil"))
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletType) is not init")
            return .error(ParticleNetwork.ResponseError(code: nil, message: "adapter for \(walletType) is not init"))
        }
        return adapter.signTypedData(publicAddress: self.getEoaAddress(), data: message)
    }
    
    public func signMessage(_ message: String) -> RxSwift.Single<String> {
        guard let walletType = self.latestWalletType else {
            print("walletType is nil")
            return .error(ParticleNetwork.ResponseError(code: nil, message: "walletType is nil"))
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletType) is not init")
            return .error(ParticleNetwork.ResponseError(code: nil, message: "adapter for \(walletType) is not init"))
        }
        return adapter.signMessage(publicAddress: self.getEoaAddress(), message: message)
    }
    
    public func getEoaAddress() -> String {
        return self.latestPublicAddress ?? ""
    }
}
