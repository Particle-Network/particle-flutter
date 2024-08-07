//
//  ParticleConnectPlugin.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

import Base58_swift
import ConnectCommon
import Flutter
import Foundation
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

public typealias ParticleCallback = FlutterResult

public class ParticleConnectPlugin: NSObject, FlutterPlugin {
    let bag = DisposeBag()
    
    var eventSink: FlutterEventSink?
    
    var latestPublicAddress: String?
    var latestWalletType: WalletType?
    
    var walletConnectAdapter: WalletConnectAdapter?
    
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
        case walletReadyState
        case connectWalletConnect
        case batchSendTransactions
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
            self.getAccounts(json as? String, callback: result)
        case .connect:
            self.connect(json as? String, callback: result)
        case .disconnect:
            self.disconnect(json as? String, callback: result)
        case .isConnected:
            self.isConnected(json as? String, callback: result)
        case .signMessage:
            self.signMessage(json as? String, callback: result)
        case .signTransaction:
            self.signTransaction(json as? String, callback: result)
        case .signAllTransactions:
            self.signAllTransactions(json as? String, callback: result)
        case .signAndSendTransaction:
            self.signAndSendTransaction(json as? String, callback: result)
        case .signTypedData:
            self.signTypedData(json as? String, callback: result)
        case .login:
            self.login(json as? String, callback: result)
        case .verify:
            self.verify(json as? String, callback: result)
        case .importPrivateKey:
            self.importPrivateKey(json as? String, callback: result)
        case .importMnemonic:
            self.importMnemonic(json as? String, callback: result)
        case .exportPrivateKey:
            self.exportPrivateKey(json as? String, callback: result)
        case .walletReadyState:
            self.walletReadyState(json as? String, callback: result)
        case .connectWalletConnect:
            self.connectWalletConnect(callback: result)
        case .batchSendTransactions:
            self.batchSendTransactions(json as? String, callback: result)
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
        let chainId = data["chain_id"].intValue
        let chainName = data["chain_name"].stringValue.lowercased()
        let chainType: ChainType = chainName == "solana" ? .solana : .evm
        guard let chainInfo = ParticleNetwork.searchChainInfo(by: chainId, chainType: chainType) else {
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
        let redirectUniversalLink = data["metadata"]["redirect"].string
        let walletConnectProjectId = data["metadata"]["walletConnectProjectId"].stringValue
        
        let dAppIconUrl = URL(string: dAppIconString) != nil ? URL(string: dAppIconString)! : URL(string: "https://connect.particle.network/icons/512.png")!
        
        let dAppUrl = URL(string: dAppUrlString) != nil ? URL(string: dAppUrlString)! : URL(string: "https://connect.particle.network")!
        
        let dAppData = DAppMetaData(name: dAppName, icon: dAppIconUrl, url: dAppUrl, description: dappDescription, redirectUniversalLink: redirectUniversalLink)
        var adapters: [ConnectAdapter] = []
        
        
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
        adapters.append(contentsOf: [
            MetaMaskConnectAdapter(),
            RainbowConnectAdapter(),
            BitkeepConnectAdapter(),
            ImtokenConnectAdapter(),
            TrustConnectAdapter(),
            WalletConnectAdapter(),
            ZerionConnectAdapter(),
            MathConnectAdapter(),
            Inch1ConnectAdapter(),
            ZengoConnectAdapter(),
            AlphaConnectAdapter(),
            OKXConnectAdapter()
        ])
        
#endif
        ParticleConnect.initialize(env: devEnv, chainInfo: chainInfo, dAppData: dAppData) {
            adapters
        }
        
        ParticleConnect.setWalletConnectV2ProjectId(walletConnectProjectId)
    }

    func setWalletConnectV2SupportChainInfos(_ json: String?) {
        guard let json = json else {
            return
        }
        
        let chainInfos = JSON(parseJSON: json).arrayValue.compactMap {
            let chainId = $0["chain_id"].intValue
            let chainName = $0["chain_name"].stringValue.lowercased()
            let chainType: ChainType = chainName == "solana" ? .solana : .evm
            return ParticleNetwork.searchChainInfo(by: chainId, chainType: chainType)
        }
        
        ParticleConnect.setWalletConnectV2SupportChainInfos(chainInfos)
    }
    
    func getAccounts(_ json: String?, callback: ParticleCallback) {
        guard let json = json else {
            callback(getErrorJson("json is nil"))
            return
        }
        
        let walletTypeString = json
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed")
            callback(getErrorJson("walletType \(walletTypeString) is not existed"))
            return
        }
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            callback(getErrorJson("adapter for \(walletTypeString) is not init"))
            return
        }
        
        let accounts = adapter.getAccounts()
        let statusModel = FlutterStatusModel(status: true, data: accounts)
        let data = try! JSONEncoder().encode(statusModel)
        let jsonString = String(data: data, encoding: .utf8) ?? ""
        callback(jsonString)
    }
    
    func connect(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else {
            callback(getErrorJson("json is nil"))
            return
        }
        
        let walletTypeString = JSON(parseJSON: json)["walletType"].stringValue
        let configJson = JSON(parseJSON: json)["particleConnectConfig"]
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed")
            callback(getErrorJson("walletType \(walletTypeString) is not existed"))
            return
        }
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            callback(getErrorJson("adapter for \(walletTypeString) is not init"))
            return
        }
        
        var particleAuthCoreConfig: ParticleAuthCoreConfig?
        
        var loginType: LoginType
        var supportAuthTypeArray: [SupportAuthType] = []
        var account: String?
        var code: String?
        var socialLoginPrompt: SocialLoginPrompt?
                
        if configJson != JSON.null {
            let data = configJson
            loginType = LoginType(rawValue: data["loginType"].stringValue.lowercased()) ?? .email
                        
            let array = data["supportAuthTypeValues"].arrayValue.map {
                $0.stringValue.lowercased()
            }
            if array.contains("all") {
                supportAuthTypeArray = [.all]
            } else {
                array.forEach { if $0 == "email" {
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
                        
            account = data["account"].string
                        
            if account != nil, account!.isEmpty {
                account = nil
            }
                    
            code = data["code"].string
            if code != nil, code!.isEmpty {
                code = nil
            }
                        
            let socialLoginPromptString = data["socialLoginPrompt"].stringValue.lowercased()
            if socialLoginPromptString == "none" {
                socialLoginPrompt = SocialLoginPrompt.none
            } else if socialLoginPromptString == "consent" {
                socialLoginPrompt = SocialLoginPrompt.consent
            } else if socialLoginPromptString == "selectaccount" {
                socialLoginPrompt = SocialLoginPrompt.selectAccount
            }
                            
            let config = data["loginPageConfig"]
            var loginPageConfig: LoginPageConfig?
            if config != JSON.null {
                let projectName = config["projectName"].stringValue
                let description = config["description"].stringValue
                let path = config["imagePath"].stringValue
                let imagePath = ImagePath.url(path)
                loginPageConfig = LoginPageConfig(imagePath: imagePath, projectName: projectName, description: description)
            }
            
            particleAuthCoreConfig = ParticleAuthCoreConfig(loginType: loginType, supportAuthType: supportAuthTypeArray, account: account, code: code, socialLoginPrompt: socialLoginPrompt, loginPageConfig: loginPageConfig)
        }
                
        var observable: Single<Account?>
        if walletType == .authCore {
            observable = adapter.connect(particleAuthCoreConfig)
        } else {
            observable = adapter.connect(ConnectConfig.none)
        }
        subscribeAndCallback(observable: observable, callback: callback)
    }
    
    func disconnect(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else {
            callback(getErrorJson("json is nil"))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed")
            callback(getErrorJson("walletType \(walletTypeString) is not existed"))
            return
        }
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            callback(getErrorJson("adapter for \(walletTypeString) is not init"))
            return
        }
        
        subscribeAndCallback(observable: adapter.disconnect(publicAddress: publicAddress), callback: callback)
    }
    
    func isConnected(_ json: String?, callback: ParticleCallback) {
        guard let json = json else {
            callback(getErrorJson("json is nil"))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed")
            callback(getErrorJson("walletType \(walletTypeString) is not existed"))
            return
        }
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            callback(getErrorJson("adapter for \(walletTypeString) is not init"))
            return
        }
        callback(adapter.isConnected(publicAddress: publicAddress))
    }
    
    func signAndSendTransaction(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else {
            callback(getErrorJson("json is nil"))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        let transaction = data["transaction"].stringValue
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed")
            callback(getErrorJson("walletType \(walletTypeString) is not existed"))
            return
        }
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            callback(getErrorJson("adapter for \(walletTypeString) is not init"))
            return
        }
        
        let mode = data["fee_mode"]["option"].stringValue
        var feeMode: AA.FeeMode = .native
        if mode == "native" {
            feeMode = .native
        } else if mode == "gasless" {
            feeMode = .gasless
        } else if mode == "token" {
            let feeQuoteJson = JSON(data["fee_mode"]["fee_quote"].dictionaryValue)
            let tokenPaymasterAddress = data["fee_mode"]["token_paymaster_address"].stringValue
            let feeQuote = AA.FeeQuote(json: feeQuoteJson, tokenPaymasterAddress: tokenPaymasterAddress)

            feeMode = .token(feeQuote)
        }
        
        let wholeFeeQuoteData = (try? data["fee_mode"]["whole_fee_quote"].rawData()) ?? Data()
        let wholeFeeQuote = try? JSONDecoder().decode(AA.WholeFeeQuote.self, from: wholeFeeQuoteData)
        
        let chainInfo = ParticleNetwork.getChainInfo()
        let aaService = ParticleNetwork.getAAService()
        var sendObservable: Single<String>
        if aaService != nil, aaService!.isAAModeEnable() {
            self.latestPublicAddress = publicAddress
            self.latestWalletType = walletType
            sendObservable = aaService!.quickSendTransactions([transaction], feeMode: feeMode, messageSigner: self, wholeFeeQuote: wholeFeeQuote, chainInfo: chainInfo)
        } else {
            sendObservable = adapter.signAndSendTransaction(publicAddress: publicAddress, transaction: transaction, feeMode: feeMode, chainInfo: chainInfo)
        }
        
        subscribeAndCallback(observable: sendObservable, callback: callback)
    }
    
    func batchSendTransactions(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else {
            callback(getErrorJson("json is nil"))
            return
        }
        
        let data = JSON(parseJSON: json)
        let transactions = data["transactions"].arrayValue.map {
            $0.stringValue
        }
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed")
            callback(getErrorJson("walletType \(walletTypeString) is not existed"))
            return
        }
        
        let mode = data["fee_mode"]["option"].stringValue
        var feeMode: AA.FeeMode = .native
        if mode == "native" {
            feeMode = .native
        } else if mode == "gasless" {
            feeMode = .gasless
        } else if mode == "token" {
            let feeQuoteJson = JSON(data["fee_mode"]["fee_quote"].dictionaryValue)
            let tokenPaymasterAddress = data["fee_mode"]["token_paymaster_address"].stringValue
            let feeQuote = AA.FeeQuote(json: feeQuoteJson, tokenPaymasterAddress: tokenPaymasterAddress)

            feeMode = .token(feeQuote)
        }
        
        let wholeFeeQuoteData = (try? data["fee_mode"]["whole_fee_quote"].rawData()) ?? Data()
        let wholeFeeQuote = try? JSONDecoder().decode(AA.WholeFeeQuote.self, from: wholeFeeQuoteData)
        guard let aaService = ParticleNetwork.getAAService() else {
            callback(getErrorJson("aa service is not init"))
            return
        }
        
        guard aaService.isAAModeEnable() else {
            callback(getErrorJson("aa service is not enable"))
            return
        }
        
        self.latestPublicAddress = publicAddress
        self.latestWalletType = walletType
        let chainInfo = ParticleNetwork.getChainInfo()
        let sendObservable = aaService.quickSendTransactions(transactions, feeMode: feeMode, messageSigner: self, wholeFeeQuote: wholeFeeQuote, chainInfo: chainInfo)
        subscribeAndCallback(observable: sendObservable, callback: callback)
    }
    
    func signTransaction(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else {
            callback(getErrorJson("json is nil"))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        let transaction = data["transaction"].stringValue
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed")
            callback(getErrorJson("walletType \(walletTypeString) is not existed"))
            return
        }
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            callback(getErrorJson("adapter for \(walletTypeString) is not init"))
            return
        }
        
        let observable = adapter.signTransaction(publicAddress: publicAddress, transaction: transaction)
        subscribeAndCallback(observable: observable, callback: callback)
    }
    
    func signAllTransactions(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else {
            callback(getErrorJson("json is nil"))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        let transactions = data["transactions"].arrayValue.map {
            $0.stringValue
        }
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed")
            callback(getErrorJson("walletType \(walletTypeString) is not existed"))
            return
        }
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            callback(getErrorJson("adapter for \(walletTypeString) is not init"))
            return
        }
        
        let observable = adapter.signAllTransactions(publicAddress: publicAddress, transactions: transactions)
        subscribeAndCallback(observable: observable, callback: callback)
    }
    
    func signMessage(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else {
            callback(getErrorJson("json is nil"))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        var message = data["message"].stringValue
        
        // solana message should encoded in base58
        if ParticleNetwork.getChainInfo().chainType == .solana {
            message = Base58.encode(message.data(using: .utf8)!)
        }
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed ")
            callback(getErrorJson("walletType \(walletTypeString) is not existed"))
            return
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            callback(getErrorJson("adapter for \(walletTypeString) is not init"))
            return
        }
        
        let observable = adapter.signMessage(publicAddress: publicAddress, message: message)
        subscribeAndCallback(observable: observable, callback: callback)
    }
    
    func signTypedData(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else {
            callback(getErrorJson("json is nil"))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        let message = data["message"].stringValue
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed")
            callback(getErrorJson("walletType \(walletTypeString) is not existed"))
            return
        }
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            callback(getErrorJson("adapter for \(walletTypeString) is not init"))
            return
        }
        
        let observable = adapter.signTypedData(publicAddress: publicAddress, data: message)
        subscribeAndCallback(observable: observable, callback: callback)
    }
    
    func importPrivateKey(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else {
            callback(getErrorJson("json is nil"))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let privateKey = data["private_key"].stringValue
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed")
            callback(getErrorJson("walletType \(walletTypeString) is not existed"))
            return
        }
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            callback(getErrorJson("adapter for \(walletTypeString) is not init"))
            return
        }
        
        guard walletType == WalletType.evmPrivateKey || walletType == WalletType.solanaPrivateKey else {
            print("walletType \(walletTypeString) is not support import from private key")
            callback(getErrorJson("walletType \(walletTypeString) is not support import from private key"))
            return
        }
        
        let observable = (adapter as! LocalAdapter).importWalletFromPrivateKey(privateKey)
        subscribeAndCallback(observable: observable, callback: callback)
    }
    
    func importMnemonic(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else {
            callback(getErrorJson("json is nil"))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let mnemonic = data["mnemonic"].stringValue
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed")
            callback(getErrorJson("walletType \(walletTypeString) is not existed"))
            return
        }
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            callback(getErrorJson("adapter for \(walletTypeString) is not init"))
            return
        }
        
        guard walletType == WalletType.evmPrivateKey || walletType == WalletType.solanaPrivateKey else {
            print("walletType \(walletTypeString) is not support import from private key")
            callback(getErrorJson("walletType \(walletTypeString) is not support import from private key"))
            return
        }
        
        let observable = (adapter as! LocalAdapter).importWalletFromMnemonic(mnemonic)
        subscribeAndCallback(observable: observable, callback: callback)
    }
    
    func exportPrivateKey(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else {
            callback(getErrorJson("json is nil"))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed")
            callback(getErrorJson("walletType \(walletTypeString) is not existed"))
            return
        }
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            callback(getErrorJson("adapter for \(walletTypeString) is not init"))
            return
        }
        
        guard walletType == WalletType.evmPrivateKey || walletType == WalletType.solanaPrivateKey else {
            print("walletType \(walletTypeString) is not support import from private key")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not support import from private key", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            callback(json)
            
            return
        }
        
        let observable = (adapter as! LocalAdapter).exportWalletPrivateKey(publicAddress: publicAddress)
        subscribeAndCallback(observable: observable, callback: callback)
    }
    
    func login(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else {
            callback(getErrorJson("json is nil"))
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
            callback(json)
            return
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            let response = FlutterResponseError(code: nil, message: "adapter for \(walletTypeString) is not init", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            callback(json)
            return
        }
        
        let siwe = try! SiweMessage(domain: domain, address: address, uri: uri)
        
        let observable = adapter.login(config: siwe, publicAddress: publicAddress).map { sourceMessage, signedMessage in
            FlutterConnectLoginResult(message: sourceMessage, signature: signedMessage)
        }
        subscribeAndCallback(observable: observable, callback: callback)
    }
    
    func verify(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else {
            callback(getErrorJson("json is nil"))
            return
        }
        
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let message = data["message"].stringValue
        var signature = data["signature"].stringValue
        
        if ParticleNetwork.getChainInfo().chainType == .solana {
            signature = Base58.encode(Data(base64Encoded: signature)!)
        }
        
        guard let walletType = map2WalletType(from: walletTypeString) else {
            print("walletType \(walletTypeString) is not existed ")
            let response = FlutterResponseError(code: nil, message: "walletType \(walletTypeString) is not existed", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            callback(json)
            return
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            let response = FlutterResponseError(code: nil, message: "adapter for \(walletTypeString) is not init", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            callback(json)
            return
        }
        
        let siwe = try! SiweMessage(message)
        
        let observable = adapter.verify(message: siwe, against: signature)
        subscribeAndCallback(observable: observable, callback: callback)
    }
    
    func walletReadyState(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else {
            callback(getErrorJson("json is nil"))
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
            callback(json)
            return
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            let response = FlutterResponseError(code: nil, message: "adapter for \(walletTypeString) is not init", data: nil)
            let statusModel = FlutterStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            callback(json)
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
        
        callback(str)
    }
    
    func connectWalletConnect(callback: @escaping ParticleCallback) {
        guard let adapter = map2ConnectAdapter(from: .walletConnect) else {
            print("adapter for walletConnect is not init")
            return
        }
        self.walletConnectAdapter = adapter as? WalletConnectAdapter
        Task {
            do {
                let (uri, observable) = try await self.walletConnectAdapter!.getConnectionUrl()
                
                subscribeAndCallback(observable: observable, callback: callback)
                
                self.eventSink?(uri)
            } catch {
                print("error \(error)")
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback(json)
            }
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

extension ParticleConnectPlugin {
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

extension ParticleConnectPlugin: MessageSigner {
    public func signMessage(_ message: String, chainInfo: ParticleNetworkBase.ParticleNetwork.ChainInfo?) -> RxSwift.Single<String> {
        guard let walletType = self.latestWalletType else {
            print("walletType is nil")
            return .error(ParticleNetwork.ResponseError(code: nil, message: "walletType is nil"))
        }
        
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletType) is not init")
            return .error(ParticleNetwork.ResponseError(code: nil, message: "adapter for \(walletType) is not init"))
        }
        return adapter.signMessage(publicAddress: self.getEoaAddress(), message: message, chainInfo: chainInfo)
    }
    
    public func getEoaAddress() -> String {
        return self.latestPublicAddress ?? ""
    }
}

extension ParticleConnectPlugin {
    private func getErrorJson(_ message: String) -> String {
        let response = FlutterResponseError(code: nil, message: message, data: nil)
        let statusModel = FlutterStatusModel(status: false, data: response)
        let data1 = try! JSONEncoder().encode(statusModel)
        guard let json = String(data: data1, encoding: .utf8) else { return "" }
        return json
    }
}
