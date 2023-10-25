//
//  ParticleAuthPlugin.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

import Base58_swift
import Flutter
import Foundation
import ParticleAuthService
import ParticleNetworkBase
import RxSwift
import SwiftyJSON

public class ParticleAuthPlugin: NSObject, FlutterPlugin {
    let bag = DisposeBag()
    
    public enum Method: String {
        case initialize
        case setChainInfo
        case getChainInfo
        case setChainInfoAsync
        case login
        case logout
        case isLogin
        case isLoginAsync
        case signMessage
        case signMessageUnique
        case signTransaction
        case signAllTransactions
        case signAndSendTransaction
        case signTypedData
        case getAddress
        case getUserInfo
        case setModalPresentStyle
        case setWebAuthConfig
        case openWebWallet
        case setMediumScreen
        case openAccountAndSecurity
        case setSecurityAccountConfig
        case setLanguage
        case fastLogout
        case batchSendTransactions
        case setCustomStyle
        case getSecurityAccount
        case setAppearance
        case setFiatCoin
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "auth_bridge", binaryMessenger: registrar.messenger())
        
        let instance = ParticleAuthPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = ParticleAuthPlugin.Method(rawValue: call.method) else {
            result(FlutterMethodNotImplemented)
            return
        }
        
        let json = call.arguments
        
        switch method {
        case .initialize:
            self.initialize(json as? String)
        case .setChainInfo:
            self.setChainInfo(json as? String, flutterResult: result)
        case .getChainInfo:
            self.getChainInfo(flutterResult: result)
        case .setChainInfoAsync:
            self.setChainInfoAsync(json as? String, flutterResult: result)
        case .login:
            self.login(json as? String, flutterResult: result)
        case .logout:
            self.logout(flutterResult: result)
        case .isLogin:
            self.isLogin(flutterResult: result)
        case .isLoginAsync:
            self.isLoginAsync(flutterResult: result)
        case .signMessage:
            self.signMessage(json as? String, flutterResult: result)
        case .signMessageUnique:
            self.signMessageUnique(json as? String, flutterResult: result)
        case .signTransaction:
            self.signTransaction(json as? String, flutterResult: result)
        case .signAllTransactions:
            self.signAllTransactions(json as? String, flutterResult: result)
        case .signAndSendTransaction:
            self.signAndSendTransaction(json as? String, flutterResult: result)
        case .signTypedData:
            self.signTypedData(json as? String, flutterResult: result)
        case .getAddress:
            self.getAddress(flutterResult: result)
        case .getUserInfo:
            self.getUserInfo(flutterResult: result)
        case .setModalPresentStyle:
            self.setModalPresentStyle(json as? String)
        case .setWebAuthConfig:
            self.setWebAuthConfig(json as? String)
        case .openWebWallet:
            self.openWebWallet(json as? String)
        case .setCustomStyle:
            self.setCustomStyle(json as? String)
        case .setMediumScreen:
            self.setMediumScreen(json as? Bool ?? false)
        case .setSecurityAccountConfig:
            self.setSecurityAccountConfig(json as? String)
        case .openAccountAndSecurity:
            self.openAccountAndSecurity(flutterResult: result)
        case .setLanguage:
            self.setLanguage(json as? String)
        case .fastLogout:
            self.fastLogout(flutterResult: result)
        case .batchSendTransactions:
            self.batchSendTransactions(json as? String, flutterResult: result)
        case .getSecurityAccount:
            self.getSecurityAccount(flutterResult: result)
        case .setAppearance:
            self.setAppearance(json as? String)
        case .setFiatCoin:
            self.setFiatCoin(json as? String)
        }
    }
}

// MARK: -  Methods

public extension ParticleAuthPlugin {
    func initialize(_ json: String?) {
        guard let json = json else {
            return
        }
        
        let data = JSON(parseJSON: json)
        let name = data["chain_name"].stringValue.lowercased()
        let chainId = data["chain_id"].intValue
        guard let chainInfo = ParticleNetwork.searchChainInfo(by: chainId) else {
            return print("initialize error, can't find right chain for \(name), chainId \(chainId)")
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
    
    func setChainInfo(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            return
        }
        
        let data = JSON(parseJSON: json)
        
        let chainId = data["chain_id"].intValue
        guard let chainInfo = ParticleNetwork.searchChainInfo(by: chainId) else {
            flutterResult(false)
            return
        }
        ParticleNetwork.setChainInfo(chainInfo)
        flutterResult(true)
    }

    func setChainInfoAsync(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        let data = JSON(parseJSON: json)
        
        let chainId = data["chain_id"].intValue
        guard let chainInfo = ParticleNetwork.searchChainInfo(by: chainId) else {
            flutterResult(FlutterError(code: "", message: "did not find chain info for \(chainId)", details: nil))
            return
        }
        ParticleAuthService.switchChain(chainInfo).subscribe { result in
            switch result {
            case .failure:
                flutterResult(false)
            case .success:
                flutterResult(true)
            }
        }.disposed(by: self.bag)
    }
    
    func getChainInfo(flutterResult: FlutterResult) {
        let chainInfo = ParticleNetwork.getChainInfo()
        
        let jsonString = ["chain_name": chainInfo.name, "chain_id": chainInfo.chainId, "chain_id_name": chainInfo.network].jsonString() ?? ""
        
        flutterResult(jsonString)
    }
    
    func login(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }

        let data = JSON(parseJSON: json)
        
        let type = data["login_type"].stringValue.lowercased()
        let account = data["account"].string
        let supportAuthType = data["support_auth_type_values"].arrayValue
        
        let socialLoginPromptString = data["social_login_prompt"].stringValue.lowercased()
        let socialLoginPrompt: SocialLoginPrompt? = SocialLoginPrompt(rawValue: socialLoginPromptString)
        
        let message: String? = data["authorization"]["message"].string
        let isUnique: Bool = data["authorization"]["uniq"].bool ?? false
        
        var loginAuthorization: LoginAuthorization?
        
        if message != nil {
            loginAuthorization = .init(message: message!, isUnique: isUnique)
        }
        
        let loginType = LoginType(rawValue: type) ?? .email
        var supportAuthTypeArray: [SupportAuthType] = []
        
        let array = supportAuthType.map {
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
        
        var acc = account
        if acc != nil, acc!.isEmpty {
            acc = nil
        }
        let observable = ParticleAuthService.login(type: loginType, account: acc, supportAuthType: supportAuthTypeArray, socialLoginPrompt: socialLoginPrompt, authorization: loginAuthorization).map { userInfo in
            let userInfoJsonString = userInfo?.jsonStringFullSnake()
            let newUserInfo = JSON(parseJSON: userInfoJsonString ?? "")
            return newUserInfo
        }
        
        subscribeAndCallback(observable: observable, flutterResult: flutterResult)
    }
    
    func logout(flutterResult: @escaping FlutterResult) {
        subscribeAndCallback(observable: ParticleAuthService.logout(), flutterResult: flutterResult)
    }
    
    func fastLogout(flutterResult: @escaping FlutterResult) {
        subscribeAndCallback(observable: ParticleAuthService.logout(), flutterResult: flutterResult)
    }
    
    func isLogin(flutterResult: @escaping FlutterResult) {
        flutterResult(ParticleAuthService.isLogin())
    }

    func isLoginAsync(flutterResult: @escaping FlutterResult) {
        let observable = ParticleAuthService.isLoginAsync().map { userInfo in
            let userInfoJsonString = userInfo.jsonStringFullSnake()
            let newUserInfo = JSON(parseJSON: userInfoJsonString)
            return newUserInfo
        }
        
        subscribeAndCallback(observable: observable, flutterResult: flutterResult)
    }
    
    func signMessage(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let message = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        var serializedMessage = ""
        switch ParticleNetwork.getChainInfo().chain {
        case .solana:
            serializedMessage = Base58.encode(message.data(using: .utf8)!)
        default:
            serializedMessage = message
        }
        
        subscribeAndCallback(observable: ParticleAuthService.signMessage(serializedMessage), flutterResult: flutterResult)
    }
    
    func signMessageUnique(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let message = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        var serializedMessage = ""
        switch ParticleNetwork.getChainInfo().chain {
        case .solana:
            serializedMessage = Base58.encode(message.data(using: .utf8)!)
        default:
            serializedMessage = message
        }
        subscribeAndCallback(observable: ParticleAuthService.signMessageUnique(serializedMessage), flutterResult: flutterResult)
    }
    
    func signTransaction(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let transaction = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        subscribeAndCallback(observable: ParticleAuthService.signTransaction(transaction), flutterResult: flutterResult)
    }
    
    func signAllTransactions(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let transactions = JSON(parseJSON: json).arrayValue.map { $0.stringValue }
        
        self.subscribeAndCallback(observable: ParticleAuthService.signAllTransactions(transactions), flutterResult: flutterResult)
    }
    
    func signAndSendTransaction(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let data = JSON(parseJSON: json)
        let transaction = data["transaction"].stringValue
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
        
        let aaService = ParticleNetwork.getAAService()
        var sendObservable: Single<String>
        if aaService != nil, aaService!.isAAModeEnable() {
            sendObservable = aaService!.quickSendTransactions([transaction], feeMode: feeMode, messageSigner: self, wholeFeeQuote: wholeFeeQuote)
        } else {
            sendObservable = ParticleAuthService.signAndSendTransaction(transaction, feeMode: feeMode)
        }
        
        subscribeAndCallback(observable: sendObservable, flutterResult: flutterResult)
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
            flutterResult(FlutterError(code: "", message: "aa service is not init", details: nil))
            return
        }
        
        guard aaService.isAAModeEnable() else {
            flutterResult(FlutterError(code: "", message: "aa service is not enable", details: nil))
            return
        }
        let sendObservable: Single<String> = aaService.quickSendTransactions(transactions, feeMode: feeMode, messageSigner: self, wholeFeeQuote: wholeFeeQuote)
        
        subscribeAndCallback(observable: sendObservable, flutterResult: flutterResult)
    }
    
    func signTypedData(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let data = JSON(parseJSON: json)
        let message = data["message"].stringValue
        let version = data["version"].stringValue.lowercased()
        var signTypedDataVersion: EVMSignTypedDataVersion?
        if version == "v1" {
            signTypedDataVersion = .v1
        } else if version == "v3" {
            signTypedDataVersion = .v3
        } else if version == "v4" {
            signTypedDataVersion = .v4
        } else if version == "v4unique" {
            signTypedDataVersion = .v4Unique
        }
        guard let signTypedDataVersion = signTypedDataVersion else {
            flutterResult(FlutterError(code: "", message: "version is wrong", details: nil))
            return
        }
       
        subscribeAndCallback(observable: ParticleAuthService.signTypedData(message, version: signTypedDataVersion), flutterResult: flutterResult)
    }
    
    func getAddress(flutterResult: @escaping FlutterResult) {
        flutterResult(ParticleAuthService.getAddress())
    }
    
    func getUserInfo(flutterResult: @escaping FlutterResult) {
        guard let userInfo = ParticleAuthService.getUserInfo() else {
            flutterResult(FlutterError(code: "", message: "user is not login", details: nil))
            return
        }
        
        let userInfoJsonString = userInfo.jsonStringFullSnake()
        let newUserInfo = JSON(parseJSON: userInfoJsonString)
        
        let data = try! JSONEncoder().encode(newUserInfo)
        let json = String(data: data, encoding: .utf8)
        flutterResult(json ?? "")
    }
    
    func setModalPresentStyle(_ json: String?) {
        guard let style = json else {
            return
        }
        if style == "fullScreen" {
            ParticleAuthService.setModalPresentStyle(.fullScreen)
        } else {
            ParticleAuthService.setModalPresentStyle(.pageSheet)
        }
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
    
    func setWebAuthConfig(_ json: String?) {
        guard let json = json else {
            return
        }
        let data = JSON(parseJSON: json)
        let isDisplayWallet = data["display_wallet"].boolValue
        let appearance = data["appearance"].stringValue.lowercased()
        
        var style: UIUserInterfaceStyle = .unspecified
        if appearance == "system" {
            style = UIUserInterfaceStyle.unspecified
        } else if appearance == "light" {
            style = UIUserInterfaceStyle.light
        } else if appearance == "dark" {
            style = UIUserInterfaceStyle.dark
        }
        
        ParticleAuthService.setWebAuthConfig(options: .init(isDisplayWallet: isDisplayWallet, appearance: style))
    }
    
    func openWebWallet(_ json: String?) {
        ParticleAuthService.openWebWallet(styleJsonString: json)
    }

    func setCustomStyle(_ json: String?) {
        ParticleAuthService.setCustomStyle(string: json!)
    }

    func setMediumScreen(_ isMediumScreen: Bool) {
        if #available(iOS 15.0, *) {
            ParticleAuthService.setMediumScreen(isMediumScreen)
        } else {
            // Fallback on earlier versions
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
    
    func openAccountAndSecurity(flutterResult: @escaping FlutterResult) {
        subscribeAndCallback(observable: ParticleAuthService.openAccountAndSecurity().map {
            ""
        }, flutterResult: flutterResult)
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
    
    func getSecurityAccount(flutterResult: @escaping FlutterResult) {
        subscribeAndCallback(observable: ParticleAuthService.getSecurityAccount().map { securityAccountInfo in
            let dict = ["phone": securityAccountInfo.phone,
                        "email": securityAccountInfo.email,
                        "has_set_master_password": securityAccountInfo.hasSetMasterPassword,
                        "has_set_payment_password": securityAccountInfo.hasSetPaymentPassword] as [String: Any?]
            
            let json = JSON(dict)
            return json
        }, flutterResult: flutterResult)
    }
}

extension ParticleAuthPlugin {
    private func subscribeAndCallback<T: Codable>(observable: Single<T>, flutterResult: @escaping FlutterResult) {
        observable.subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            case .success(let signedMessage):
                let statusModel = FlutterStatusModel(status: true, data: signedMessage)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            }
        }.disposed(by: self.bag)
    }
}

extension ParticleAuthPlugin: MessageSigner {
    public func signMessage(_ message: String) -> RxSwift.Single<String> {
        return ParticleAuthService.signMessage(message)
    }
    
    public func getEoaAddress() -> String {
        ParticleAuthService.getAddress()
    }
}
