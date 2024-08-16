//
//  ShareConnect.swift
//  particle_connect
//
//  Created by link on 15/08/2024.
//

import AuthCoreAdapter
import Base58_swift
import ConnectCommon
import ConnectEVMAdapter
import ConnectPhantomAdapter
import ConnectSolanaAdapter
import ConnectWalletConnectAdapter
import Foundation
import ParticleConnect
import ParticleConnectKit
import ParticleNetworkBase
import ParticleNetworkChains
import RxSwift
import SwiftyJSON

typealias ShareCallback = (Any) -> Void

class ShareConnect {
    static let shared: ShareConnect = .init()
    var latestPublicAddress: String?
    var latestWalletType: WalletType?
    
    var walletConnectAdapter: WalletConnectAdapter?
    
    let bag = DisposeBag()
    
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
        
        let adapters: [ConnectAdapter] = [
            AuthCoreAdapter(),
            MetaMaskConnectAdapter(),
            RainbowConnectAdapter(),
            BitgetConnectAdapter(),
            ImtokenConnectAdapter(),
            TrustConnectAdapter(),
            WalletConnectAdapter(),
            ZerionConnectAdapter(),
            MathConnectAdapter(),
            Inch1ConnectAdapter(),
            ZengoConnectAdapter(),
            AlphaConnectAdapter(),
            OKXConnectAdapter(),
            PhantomConnectAdapter(),
            SolanaConnectAdapter(),
            EVMConnectAdapter()
        ]
        
        ParticleConnect.initialize(env: devEnv, chainInfo: chainInfo, dAppData: dAppData, adapters: adapters)
        
        ParticleConnect.setWalletConnectV2ProjectId(walletConnectProjectId)
    }

    func setWalletConnectV2SupportChainInfos(_ json: String) {
        let chainInfos = JSON(parseJSON: json).arrayValue.compactMap {
            let chainId = $0["chain_id"].intValue
            let chainName = $0["chain_name"].stringValue.lowercased()
            let chainType: ChainType = chainName == "solana" ? .solana : .evm
            return ParticleNetwork.searchChainInfo(by: chainId, chainType: chainType)
        }
        
        ParticleConnect.setWalletConnectV2SupportChainInfos(chainInfos)
    }
    
    func getAccounts(_ json: String) -> String {
        let walletTypeString = json
        var accounts: [Account] = []
        if let walletType = WalletType.fromString(walletTypeString), let adapter = map2ConnectAdapter(from: walletType) {
            accounts = adapter.getAccounts()
        } else {
            accounts = []
        }
        
        let statusModel = PNStatusModel(status: true, data: accounts)
        let data = try! JSONEncoder().encode(statusModel)
        let jsonString = String(data: data, encoding: .utf8) ?? ""
        return jsonString
    }
    
    func connectWithConnectKitConfig(_ json: String, callback: @escaping ShareCallback) {
        let data = JSON(parseJSON: json)
        let connectOptions: [ConnectOption] = data["connectOptions"].arrayValue.compactMap {
            ConnectOption(rawValue: $0.stringValue.lowercased())
        }
        
        let socialProviders: [EnableSocialProvider] = data["socialProviders"].arrayValue.compactMap {
            EnableSocialProvider(rawValue: $0.stringValue.lowercased())
        }
        
        let walletProviders: [EnableWalletProvider] = data["walletProviders"].arrayValue.compactMap {
            let label = $0["label"].stringValue.lowercased()
            let name = $0["enableWallet"].stringValue.lowercased()
            return EnableWalletProvider(name: name, state: .init(rawValue: label) ?? .none)
        }
        
        let layoutJson = data["additionalLayoutOptions"]
        
        let additionalLayoutOptions: AdditionalLayoutOptions = .init(isCollapseWalletList: layoutJson["isCollapseWalletList"].boolValue, isSplitEmailAndSocial: layoutJson["isSplitEmailAndSocial"].boolValue, isSplitEmailAndPhone: layoutJson["isSplitEmailAndPhone"].boolValue, isHideContinueButton: layoutJson["isHideContinueButton"].boolValue)
        let path = data["logo"].stringValue
        var imagePath: ImagePath?
        if let data = Data(base64Encoded: path), let image = UIImage(data: data) {
            imagePath = ImagePath.local(image)
        } else if !path.isEmpty {
            imagePath = ImagePath.url(path)
        } else {
            imagePath = nil
        }
        
        let designOptions = DesignOptions(icon: imagePath)
        let config: ConnectKitConfig = .init(connectOptions: connectOptions, socialProviders: socialProviders, walletProviders: walletProviders, additionalLayoutOptions: additionalLayoutOptions, designOptions: designOptions)
        
        let observable: Single<Account> = ParticleConnectUI.connect(config: config)
        
        subscribeAndCallback(observable: observable, callback: callback)
    }
    
    func connect(_ json: String, callback: @escaping ShareCallback) {
        let walletTypeString = JSON(parseJSON: json)["walletType"].stringValue
        let configJson = JSON(parseJSON: json)["particleConnectConfig"]
        
        guard let walletType = WalletType.fromString(walletTypeString) else {
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
            } else if socialLoginPromptString == "selectaccount" || socialLoginPromptString == "select_account" {
                socialLoginPrompt = SocialLoginPrompt.selectAccount
            }
                     
            let config = data["login_page_config"] != JSON.null ? data["login_page_config"] : data["loginPageConfig"]
            
            var loginPageConfig: LoginPageConfig?
            if config != JSON.null {
                let projectName = config["projectName"].stringValue
                let description = config["description"].stringValue
                let path = config["imagePath"].stringValue
                var imagePath: ImagePath

                if let data = Data(base64Encoded: path), let image = UIImage(data: data) {
                    imagePath = ImagePath.local(image)
                } else {
                    imagePath = ImagePath.url(path)
                }

                loginPageConfig = LoginPageConfig(imagePath: imagePath, projectName: projectName, description: description)
            }
            
            particleAuthCoreConfig = ParticleAuthCoreConfig(loginType: loginType, supportAuthType: supportAuthTypeArray, account: account, code: code, socialLoginPrompt: socialLoginPrompt, loginPageConfig: loginPageConfig)
        }
                
        var observable: Single<Account>
        if walletType == .authCore {
            observable = adapter.connect(particleAuthCoreConfig)
        } else {
            observable = adapter.connect(ConnectConfig.none)
        }
        subscribeAndCallback(observable: observable, callback: callback)
    }
    
    func disconnect(_ json: String, callback: @escaping ShareCallback) {
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        
        guard let walletType = WalletType.fromString(walletTypeString) else {
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
    
    func isConnected(_ json: String, callback: ShareCallback) {
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        
        guard let walletType = WalletType.fromString(walletTypeString) else {
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
    
    func signAndSendTransaction(_ json: String, callback: @escaping ShareCallback) {
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        let transaction = data["transaction"].stringValue
        
        guard let walletType = WalletType.fromString(walletTypeString) else {
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
    
    func batchSendTransactions(_ json: String, callback: @escaping ShareCallback) {
        let data = JSON(parseJSON: json)
        let transactions = data["transactions"].arrayValue.map {
            $0.stringValue
        }
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        
        guard let walletType = WalletType.fromString(walletTypeString) else {
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
            print("aa service is not init")
            callback(getErrorJson("aa service is not init"))
            return
        }
        
        guard aaService.isAAModeEnable() else {
            print("aa service is not enable")
            callback(getErrorJson("aa service is not enable"))
            return
        }
        
        self.latestPublicAddress = publicAddress
        self.latestWalletType = walletType
        let chainInfo = ParticleNetwork.getChainInfo()
        let sendObservable = aaService.quickSendTransactions(transactions, feeMode: feeMode, messageSigner: self, wholeFeeQuote: wholeFeeQuote, chainInfo: chainInfo)
        subscribeAndCallback(observable: sendObservable, callback: callback)
    }
    
    func signTransaction(_ json: String, callback: @escaping ShareCallback) {
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        let transaction = data["transaction"].stringValue
        
        guard let walletType = WalletType.fromString(walletTypeString) else {
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
    
    func signAllTransactions(_ json: String, callback: @escaping ShareCallback) {
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        let transactions = data["transactions"].arrayValue.map {
            $0.stringValue
        }
        
        guard let walletType = WalletType.fromString(walletTypeString) else {
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
    
    func signMessage(_ json: String, callback: @escaping ShareCallback) {
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        var message = data["message"].stringValue
        
        // solana message should encoded in base58
        if ParticleNetwork.getChainInfo().chainType == .solana {
            message = Base58.encode(message.data(using: .utf8)!)
        }
        
        guard let walletType = WalletType.fromString(walletTypeString) else {
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
    
    func signTypedData(_ json: String, callback: @escaping ShareCallback) {
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        let message = data["message"].stringValue
        
        guard let walletType = WalletType.fromString(walletTypeString) else {
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
    
    func importPrivateKey(_ json: String, callback: @escaping ShareCallback) {
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let privateKey = data["private_key"].stringValue
        
        guard let walletType = WalletType.fromString(walletTypeString) else {
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
    
    func importMnemonic(_ json: String, callback: @escaping ShareCallback) {
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let mnemonic = data["mnemonic"].stringValue
        
        guard let walletType = WalletType.fromString(walletTypeString) else {
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
    
    func exportPrivateKey(_ json: String, callback: @escaping ShareCallback) {
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        
        guard let walletType = WalletType.fromString(walletTypeString) else {
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
        
        let observable = (adapter as! LocalAdapter).exportWalletPrivateKey(publicAddress: publicAddress)
        subscribeAndCallback(observable: observable, callback: callback)
    }
    
    func signInWithEthereum(_ json: String, callback: @escaping ShareCallback) {
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let publicAddress = data["public_address"].stringValue
        let domain = data["domain"].stringValue
        let address = publicAddress
        guard let uri = URL(string: data["uri"].stringValue) else { return }
        
        guard let walletType = WalletType.fromString(walletTypeString) else {
            print("walletType \(walletTypeString) is not existed")
            callback(getErrorJson("walletType \(walletTypeString) is not existed"))
            return
        }
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            callback(getErrorJson("adapter for \(walletTypeString) is not init"))
            return
        }
        
        let siwe = try! SiweMessage(domain: domain, address: address, uri: uri)
        let observable = adapter.signInWithEthereum(config: siwe, publicAddress: publicAddress).map { sourceMessage, signedMessage in
            PNConnectLoginResult(message: sourceMessage, signature: signedMessage)
        }
        subscribeAndCallback(observable: observable, callback: callback)
    }
    
    func verify(_ json: String, callback: @escaping ShareCallback) {
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue
        let message = data["message"].stringValue
        var signature = data["signature"].stringValue
        
        if ParticleNetwork.getChainInfo().chainType == .solana {
            signature = Base58.encode(Data(base64Encoded: signature)!)
        }
        
        guard let walletType = WalletType.fromString(walletTypeString) else {
            print("walletType \(walletTypeString) is not existed")
            callback(getErrorJson("walletType \(walletTypeString) is not existed"))
            return
        }
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            callback(getErrorJson("adapter for \(walletTypeString) is not init"))
            return
        }
        
        let siwe = try! SiweMessage(message)
        
        let observable = adapter.verify(message: siwe, against: signature)
        subscribeAndCallback(observable: observable, callback: callback)
    }
    
    func walletReadyState(_ json: String, callback: @escaping ShareCallback) {
        let data = JSON(parseJSON: json)
        let walletTypeString = data["wallet_type"].stringValue

        guard let walletType = WalletType.fromString(walletTypeString) else {
            print("walletType \(walletTypeString) is not existed")
            callback(getErrorJson("walletType \(walletTypeString) is not existed"))
            return
        }
        guard let adapter = map2ConnectAdapter(from: walletType) else {
            print("adapter for \(walletTypeString) is not init")
            callback(getErrorJson("adapter for \(walletTypeString) is not init"))
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
    
    func connectWalletConnect(callback: @escaping ShareCallback, eventCallback: @escaping ShareCallback) {
        guard let adapter = map2ConnectAdapter(from: .walletConnect) else {
            print("adapter for walletConnect is not init")
            return
        }
        self.walletConnectAdapter = adapter as? WalletConnectAdapter
        Task {
            do {
                let (uri, observable) = try await self.walletConnectAdapter!.getConnectionUrl()
                
                subscribeAndCallback(observable: observable, callback: callback)
                eventCallback(uri)
            } catch {
                print("error \(error)")
                let response = responseFromError(error)
                let statusModel = PNStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback(json)
            }
        }
    }
}

extension ShareConnect {
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

extension ShareConnect: MessageSigner {
    public func signMessage(_ message: String, chainInfo: ChainInfo?) -> RxSwift.Single<String> {
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

extension ShareConnect {
    private func getErrorJson(_ message: String) -> String {
        let response = PNResponseError(code: nil, message: message, data: nil)
        let statusModel = PNStatusModel(status: false, data: response)
        let data = try! JSONEncoder().encode(statusModel)
        guard let json = String(data: data, encoding: .utf8) else { return "" }
        return json
    }
}
