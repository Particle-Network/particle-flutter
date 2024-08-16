//
//  ShareAuthCore.swift
//  particle_auth_core
//
//  Created by link on 15/08/2024.
//

import AuthCoreAdapter
import Base58_swift
import ConnectCommon
import Foundation
import ParticleAuthCore
import ParticleNetworkBase
import ParticleNetworkChains
import RxSwift
import SwiftyJSON

typealias ShareCallback = (Any) -> Void

class ShareAuthCore {
    static let shared: ShareAuthCore = .init()

    let auth = Auth()

    let bag = DisposeBag()

    func initialize() {
        ConnectManager.setMoreAdapters([AuthCoreAdapter()])
    }

    func switchChain(_ json: String, callback: @escaping ShareCallback) {
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

    func connect(_ json: String, callback: @escaping ShareCallback) {
        let data = JSON(parseJSON: json)

        let type = ((data["login_type"].string ?? data["loginType"].string) ?? "").lowercased()

        let account = data["account"].string
        let supportAuthType = (data["support_auth_type_values"].array ?? data["supportAuthTypeValues"].array) ?? []

        let socialLoginPromptString = (data["social_login_prompt"].string ?? data["socialLoginPrompt"].string ?? "").lowercased()

        var socialLoginPrompt: SocialLoginPrompt?
        if socialLoginPromptString == "none" {
            socialLoginPrompt = SocialLoginPrompt.none
        } else if socialLoginPromptString == "consent" {
            socialLoginPrompt = SocialLoginPrompt.consent
        } else if socialLoginPromptString == "select_account" || socialLoginPromptString == "selectaccount" {
            socialLoginPrompt = SocialLoginPrompt.selectAccount
        }

        let loginType = LoginType(rawValue: type) ?? .email

        let array = supportAuthType.map {
            $0.stringValue.lowercased()
        }

        var supportAuthTypeArray: [SupportAuthType] = []

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

        var acc = account
        if acc != nil, acc!.isEmpty {
            acc = nil
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

    func sendPhoneCode(_ json: String, callback: @escaping ShareCallback) {
        let phone = json
        let observable = Single<Bool>.fromAsync { [weak self] in
            guard let self = self else { throw ParticleNetwork.ResponseError(code: nil, message: "self is nil") }
            return try await self.auth.sendPhoneCode(phone: phone)
        }
        subscribeAndCallback(observable: observable, callback: callback)
    }

    func sendEmailCode(_ json: String, callback: @escaping ShareCallback) {
        let email = json

        let observable = Single<Bool>.fromAsync { [weak self] in
            guard let self = self else { throw ParticleNetwork.ResponseError(code: nil, message: "self is nil") }
            return try await self.auth.sendEmailCode(email: email)
        }
        subscribeAndCallback(observable: observable, callback: callback)
    }

    func connectWithCode(_ json: String, callback: @escaping ShareCallback) {
        let data = JSON(parseJSON: json)
        let email = data["email"].stringValue
        let phone = data["phone"].stringValue
        let code = data["code"].stringValue
        if !email.isEmpty {
            let observable = Single<UserInfo>.fromAsync { [weak self] in
                guard let self = self else { throw ParticleNetwork.ResponseError(code: nil, message: "self is nil") }
                return try await self.auth.connect(type: LoginType.email, account: email, code: code)
            }.map { userInfo in
                let userInfoJsonString = userInfo.jsonStringFullSnake()
                let newUserInfo = JSON(parseJSON: userInfoJsonString)
                return newUserInfo
            }
            subscribeAndCallback(observable: observable, callback: callback)
        } else {
            let observable = Single<UserInfo>.fromAsync { [weak self] in
                guard let self = self else { throw ParticleNetwork.ResponseError(code: nil, message: "self is nil") }
                return try await self.auth.connect(type: LoginType.phone, account: phone, code: code)
            }.map { userInfo in
                let userInfoJsonString = userInfo.jsonStringFullSnake()
                let newUserInfo = JSON(parseJSON: userInfoJsonString)
                return newUserInfo
            }

            subscribeAndCallback(observable: observable, callback: callback)
        }
    }

    func disconnect(_ callback: @escaping ShareCallback) {
        subscribeAndCallback(observable: Single<String>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.disconnect()
        }, callback: callback)
    }

    func isConnected(_ callback: @escaping ShareCallback) {
        subscribeAndCallback(observable: Single<Bool>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.isConnected()
        }, callback: callback)
    }

    func solanaSignMessage(_ json: String, callback: @escaping ShareCallback) {
        let message = json
        let serializedMessage = Base58.encode(message.data(using: .utf8)!)

        let chainInfo = ParticleNetwork.getChainInfo()
        subscribeAndCallback(observable: Single<String>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.solana.signMessage(serializedMessage, chainInfo: chainInfo)
        }, callback: callback)
    }

    func solanaSignTransaction(_ json: String, callback: @escaping ShareCallback) {
        let transaction = json
        let chainInfo = ParticleNetwork.getChainInfo()
        subscribeAndCallback(observable: Single<String>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.solana.signTransaction(transaction, chainInfo: chainInfo)
        }, callback: callback)
    }

    func solanaSignAllTransactions(_ json: String, callback: @escaping ShareCallback) {
        let transactions = JSON(parseJSON: json).arrayValue.map { $0.stringValue }
        let chainInfo = ParticleNetwork.getChainInfo()
        subscribeAndCallback(observable: Single<[String]>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.solana.signAllTransactions(transactions, chainInfo: chainInfo)
        }, callback: callback)
    }

    func solanaSignAndSendTransaction(_ json: String, callback: @escaping ShareCallback) {
        let transaction = json
        let chainInfo = ParticleNetwork.getChainInfo()
        subscribeAndCallback(observable: Single<String>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.solana.signAndSendTransaction(transaction, chainInfo: chainInfo)
        }, callback: callback)
    }

    func evmPersonalSign(_ message: String, callback: @escaping ShareCallback) {
        let chainInfo = ParticleNetwork.getChainInfo()
        subscribeAndCallback(observable: Single<String>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.evm.personalSign(message, chainInfo: chainInfo)
        }, callback: callback)
    }

    func evmPersonalSignUnique(_ message: String, callback: @escaping ShareCallback) {
        let chainInfo = ParticleNetwork.getChainInfo()
        subscribeAndCallback(observable: Single<String>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.evm.personalSignUnique(message, chainInfo: chainInfo)
        }, callback: callback)
    }

    func evmSignTypedData(_ message: String, callback: @escaping ShareCallback) {
        let chainInfo = ParticleNetwork.getChainInfo()
        subscribeAndCallback(observable: Single<String>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.evm.signTypedData(message, chainInfo: chainInfo)
        }, callback: callback)
    }

    func evmSignTypedDataUnique(_ message: String, callback: @escaping ShareCallback) {
        let chainInfo = ParticleNetwork.getChainInfo()
        subscribeAndCallback(observable: Single<String>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.evm.signTypedDataUnique(message, chainInfo: chainInfo)
        }, callback: callback)
    }

    func evmSendTransaction(_ json: String, callback: @escaping ShareCallback) {
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

    func evmBatchSendTransactions(_ json: String, callback: @escaping ShareCallback) {
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

    func solanaGetAddress() -> String {
        let address = self.auth.solana.getAddress()
        return address ?? ""
    }

    func evmGetAddress() -> String {
        let address = self.auth.evm.getAddress()
        return address ?? ""
    }

    func getUserInfo() -> String {
        guard let userInfo = auth.getUserInfo() else {
            return ""
        }
        let userInfoJsonString = userInfo.jsonStringFullSnake()
        let newUserInfo = JSON(parseJSON: userInfoJsonString)

        let data = try! JSONEncoder().encode(newUserInfo)
        let json = String(data: data, encoding: .utf8)!
        return json
    }

    func openAccountAndSecurity(_ callback: @escaping ShareCallback) {
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

    func hasPaymentPassword(_ callback: @escaping ShareCallback) {
        subscribeAndCallback(observable: Single<Bool>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try self.auth.hasPaymentPassword()
        }, callback: callback)
    }

    func hasMasterPassword(_ callback: @escaping ShareCallback) {
        subscribeAndCallback(observable: Single<Bool>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try self.auth.hasMasterPassword()
        }, callback: callback)
    }

    func changeMasterPassword(_ callback: @escaping ShareCallback) {
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

    func getBlindEnable() -> Bool {
        let enable = Auth.getBlindEnable()
        return enable
    }
}

extension ShareAuthCore {
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

extension ShareAuthCore: MessageSigner {
    public func signMessage(_ message: String, chainInfo: ChainInfo?) -> RxSwift.Single<String> {
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
