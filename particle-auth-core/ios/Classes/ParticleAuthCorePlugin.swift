//
//  ParticleAuthCorePlugin.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

import AuthCoreAdapter
import Base58_swift
import ConnectCommon
import Flutter
import Foundation
import ParticleAuthCore
import ParticleNetworkBase
import RxSwift
import SwiftyJSON

public typealias ParticleCallback = FlutterResult

public class ParticleAuthCorePlugin: NSObject, FlutterPlugin {
    let bag = DisposeBag()

    let auth = Auth()

    public enum Method: String {
        case initialize
        case switchChain
        case connect
        case disconnect
        case isConnected
        case solanaSignMessage
        case solanaSignTransaction
        case solanaSignAllTransactions
        case solanaSignAndSendTransaction
        case evmPersonalSign
        case evmPersonalSignUnique
        case evmSignTypedData
        case evmSignTypedDataUnique
        case evmSendTransaction
        case evmBatchSendTransactions
        case solanaGetAddress
        case evmGetAddress
        case getUserInfo
        case openAccountAndSecurity
        case hasPaymentPassword
        case hasMasterPassword
        case changeMasterPassword
        case setBlindEnable
        case getBlindEnable
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "auth_core_bridge", binaryMessenger: registrar.messenger())

        let instance = ParticleAuthCorePlugin()

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
            self.initialize()
        case .switchChain:
            self.switchChain(json as? String, callback: result)
        case .connect:
            self.connect(json as? String, callback: result)
        case .disconnect:
            self.disconnect(result)
        case .isConnected:
            self.isConnected(result)
        case .solanaSignMessage:
            self.solanaSignMessage(json as? String, callback: result)
        case .solanaSignTransaction:
            self.solanaSignTransaction(json as? String, callback: result)
        case .solanaSignAllTransactions:
            self.solanaSignAllTransactions(json as? String, callback: result)
        case .solanaSignAndSendTransaction:
            self.solanaSignAndSendTransaction(json as? String, callback: result)
        case .evmPersonalSign:
            self.evmPersonalSign(json as? String, callback: result)
        case .evmPersonalSignUnique:
            self.evmPersonalSignUnique(json as? String, callback: result)
        case .evmSignTypedData:
            self.evmSignTypedData(json as? String, callback: result)
        case .evmSignTypedDataUnique:
            self.evmSignTypedDataUnique(json as? String, callback: result)
        case .evmSendTransaction:
            self.evmSendTransaction(json as? String, callback: result)
        case .evmBatchSendTransactions:
            self.evmBatchSendTransactions(json as? String, callback: result)
        case .solanaGetAddress:
            self.solanaGetAddress(result)
        case .evmGetAddress:
            self.evmGetAddress(result)
        case .getUserInfo:
            self.getUserInfo(result)
        case .openAccountAndSecurity:
            self.openAccountAndSecurity(result)
        case .hasPaymentPassword:
            self.hasPaymentPassword(result)
        case .hasMasterPassword:
            self.hasMasterPassword(result)
        case .changeMasterPassword:
            self.changeMasterPassword(result)
        case .setBlindEnable:
            self.setBlindEnable(json as? Bool ?? false)
        case .getBlindEnable:
            self.getBlindEnable(result)
        }
    }
}

// MARK: -  Methods

public extension ParticleAuthCorePlugin {
    func initialize() {
        ConnectManager.setMoreAdapters([AuthCoreAdapter()])
    }

    func switchChain(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else {
            callback(getErrorJson("json is nil"))
            return
        }
        let data = JSON(parseJSON: json)

        let chainId = data["chain_id"].intValue
        let chainName = data["chain_name"].stringValue.lowercased()
        let chainType: ChainType = chainName == "solana" ? .solana : .evm
        guard let chainInfo = ParticleNetwork.searchChainInfo(by: chainId, chainType: chainType) else {
            callback(false)
            return
        }

        Task {
            do {
                let flag = try await auth.switchChain(chainInfo: chainInfo)
                callback(flag)
            } catch {
                callback(false)
            }
        }
    }

    func connect(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else {
            callback(getErrorJson("json is nil"))
            return
        }

        let data = JSON(parseJSON: json)

        let type = data["login_type"].stringValue.lowercased()
        let account = data["account"].string
        let supportAuthType = data["support_auth_type_values"].arrayValue

        let socialLoginPromptString = data["social_login_prompt"].stringValue.lowercased()
        let socialLoginPrompt: SocialLoginPrompt? = SocialLoginPrompt(rawValue: socialLoginPromptString)

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

        let config = data["login_page_config"]
        var loginPageConfig: LoginPageConfig?
        if config != JSON.null {
            let projectName = config["projectName"].stringValue
            let description = config["description"].stringValue
            let data = config["imagePath"].stringValue
            let imageType = config["imageType"].stringValue.lowercased()
            var imagePath: ImagePath
            if imageType == "base64" {
                imagePath = ImagePath.data(data)
            } else {
                imagePath = ImagePath.url(data)
            }
            loginPageConfig = LoginPageConfig(imagePath: imagePath, projectName: projectName, description: description)
        }

        let observable = Single<String>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.presentLoginPage(type: loginType, account: account, supportAuthType: supportAuthTypeArray, socialLoginPrompt: socialLoginPrompt, config: loginPageConfig)
        }.map { userInfo in
            let userInfoJsonString = userInfo.jsonStringFullSnake()
            let newUserInfo = JSON(parseJSON: userInfoJsonString)
            return newUserInfo
        }

        subscribeAndCallback(observable: observable, callback: callback)
    }

    func disconnect(_ callback: @escaping ParticleCallback) {
        subscribeAndCallback(observable: Single<String>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.disconnect()
        }, callback: callback)
    }

    func isConnected(_ callback: @escaping ParticleCallback) {
        subscribeAndCallback(observable: Single<Bool>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.isConnected()
        }, callback: callback)
    }

    func solanaSignMessage(_ json: String?, callback: @escaping ParticleCallback) {
        guard let message = json else {
            callback(getErrorJson("json is nil"))
            return
        }
        let serializedMessage = Base58.encode(message.data(using: .utf8)!)

        let chainInfo = ParticleNetwork.getChainInfo()
        subscribeAndCallback(observable: Single<String>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.solana.signMessage(serializedMessage, chainInfo: chainInfo)
        }, callback: callback)
    }

    func solanaSignTransaction(_ json: String?, callback: @escaping ParticleCallback) {
        guard let transaction = json else { callback(getErrorJson("json is nil"))
            return
        }
        let chainInfo = ParticleNetwork.getChainInfo()
        subscribeAndCallback(observable: Single<String>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.solana.signTransaction(transaction, chainInfo: chainInfo)
        }, callback: callback)
    }

    func solanaSignAllTransactions(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else { callback(getErrorJson("json is nil"))
            return
        }
        let transactions = JSON(parseJSON: json).arrayValue.map { $0.stringValue }
        let chainInfo = ParticleNetwork.getChainInfo()
        subscribeAndCallback(observable: Single<[String]>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.solana.signAllTransactions(transactions, chainInfo: chainInfo)
        }, callback: callback)
    }

    func solanaSignAndSendTransaction(_ transaction: String?, callback: @escaping ParticleCallback) {
        guard let transaction = transaction else { callback(getErrorJson("json is nil"))
            return
        }
        let chainInfo = ParticleNetwork.getChainInfo()
        subscribeAndCallback(observable: Single<String>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.solana.signAndSendTransaction(transaction, chainInfo: chainInfo)
        }, callback: callback)
    }

    func evmPersonalSign(_ message: String?, callback: @escaping ParticleCallback) {
        guard let message = message else { callback(getErrorJson("json is nil"))
            return
        }
        let chainInfo = ParticleNetwork.getChainInfo()
        subscribeAndCallback(observable: Single<String>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.evm.personalSign(message, chainInfo: chainInfo)
        }, callback: callback)
    }

    func evmPersonalSignUnique(_ message: String?, callback: @escaping ParticleCallback) {
        guard let message = message else { callback(getErrorJson("json is nil"))
            return
        }
        let chainInfo = ParticleNetwork.getChainInfo()
        subscribeAndCallback(observable: Single<String>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.evm.personalSignUnique(message, chainInfo: chainInfo)
        }, callback: callback)
    }

    func evmSignTypedData(_ message: String?, callback: @escaping ParticleCallback) {
        guard let message = message else {
            callback(getErrorJson("json is nil"))
            return
        }
        let chainInfo = ParticleNetwork.getChainInfo()
        subscribeAndCallback(observable: Single<String>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.evm.signTypedData(message, chainInfo: chainInfo)
        }, callback: callback)
    }

    func evmSignTypedDataUnique(_ message: String?, callback: @escaping ParticleCallback) {
        guard let message = message else {
            callback(getErrorJson("json is nil"))
            return
        }
        let chainInfo = ParticleNetwork.getChainInfo()
        subscribeAndCallback(observable: Single<String>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.evm.signTypedDataUnique(message, chainInfo: chainInfo)
        }, callback: callback)
    }

    func evmSendTransaction(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else { callback(getErrorJson("json is nil"))
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
        let chainInfo = ParticleNetwork.getChainInfo()
        if aaService != nil, aaService!.isAAModeEnable() {
            sendObservable = aaService!.quickSendTransactions([transaction], feeMode: feeMode, messageSigner: self, wholeFeeQuote: wholeFeeQuote, chainInfo: chainInfo)
        } else {
            sendObservable = Single<String>.fromAsync { [weak self] in
                guard let self = self else { throw ParticleNetwork.ResponseError(code: nil, message: "self is nil") }
                return try await self.auth.evm.sendTransaction(transaction, feeMode: feeMode, chainInfo: chainInfo)
            }
        }

        subscribeAndCallback(observable: sendObservable, callback: callback)
    }
    
    func evmBatchSendTransactions(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else { callback(getErrorJson("json is nil"))
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
            print("aa service is not init")
            return
        }

        guard aaService.isAAModeEnable() else {
            print("aa service is not enable")
            return
        }

        let chainInfo = ParticleNetwork.getChainInfo()
        let sendObservable: Single<String> = aaService.quickSendTransactions(transactions, feeMode: feeMode, messageSigner: self, wholeFeeQuote: wholeFeeQuote, chainInfo: chainInfo)

        subscribeAndCallback(observable: sendObservable, callback: callback)
    }

    func solanaGetAddress(_ callback: @escaping ParticleCallback) {
        let address = self.auth.solana.getAddress()
        callback(address)
    }

    func evmGetAddress(_ callback: @escaping ParticleCallback) {
        let address = self.auth.evm.getAddress()
        callback(address)
    }

    func getUserInfo(_ callback: @escaping ParticleCallback) {
        guard let userInfo = self.auth.getUserInfo() else {
            callback("")
            return
        }

        let userInfoJsonString = userInfo.jsonStringFullSnake()
        let newUserInfo = JSON(parseJSON: userInfoJsonString)

        let data = try! JSONEncoder().encode(newUserInfo)
        let json = String(data: data, encoding: .utf8)
        callback(json ?? "")
    }

    func openAccountAndSecurity(_ callback: @escaping ParticleCallback) {
        let observable = Single<Void>.fromAsync {
            [weak self] in
                guard let self = self else {
                    throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
                }
                try self.auth.openAccountAndSecurity()
        }.map {
            ""
        }

        subscribeAndCallback(observable: observable, callback: callback)
    }

    func hasPaymentPassword(_ callback: @escaping ParticleCallback) {
        subscribeAndCallback(observable: Single<Bool>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try self.auth.hasPaymentPassword()
        }, callback: callback)
    }

    func hasMasterPassword(_ callback: @escaping ParticleCallback) {
        subscribeAndCallback(observable: Single<Bool>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try self.auth.hasMasterPassword()
        }, callback: callback)
    }

    func changeMasterPassword(_ callback: @escaping ParticleCallback) {
        subscribeAndCallback(observable: Single<Bool>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.changeMasterPassword()
        }, callback: callback)
    }

    func setBlindEnable(_ enable: Bool) {
        Auth.setBlindEnable(enable)
    }

    func getBlindEnable(_ callback: @escaping ParticleCallback) {
        let enable = Auth.getBlindEnable()
        callback(enable)
    }
}

public extension Dictionary {
    /// - Parameter prettify: set true to prettify string (default is false).
    /// - Returns: optional JSON String (if applicable).
    func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}

extension ParticleAuthCorePlugin {
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

extension ParticleAuthCorePlugin: MessageSigner {
    public func signMessage(_ message: String, chainInfo: ParticleNetworkBase.ParticleNetwork.ChainInfo?) -> RxSwift.Single<String> {
        return Single<String>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.evm.personalSign(message, chainInfo: chainInfo)
        }
    }

    public func getEoaAddress() -> String {
        return self.auth.evm.getAddress() ?? ""
    }
}

extension Single {
    static func fromAsync<T>(_ fn: @escaping () async throws -> T) -> Single<T> {
        .create { observer in
            let task = Task {
                do { try await observer(.success(fn())) }
                catch { observer(.failure(error)) }
            }
            return Disposables.create { task.cancel() }
        }.observe(on: MainScheduler.instance)
    }
}

extension ParticleAuthCorePlugin {
    private func getErrorJson(_ message: String) -> String {
        let response = FlutterResponseError(code: nil, message: message, data: nil)
        let statusModel = FlutterStatusModel(status: false, data: response)
        let data1 = try! JSONEncoder().encode(statusModel)
        guard let json = String(data: data1, encoding: .utf8) else { return "" }
        return json
    }
}
