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
        case solanaGetAddress
        case evmGetAddress
        case getUserInfo
        case openAccountAndSecurity
        case hasPaymentPassword
        case hasMasterPassword
        case changeMasterPassword
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
        guard let jwt = json else {
            callback(getErrorJson("json is nil"))
            return
        }

        let observable = Single<String>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.connect(jwt: jwt)
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
        subscribeAndCallback(observable: Single<Bool>.fromAsync { [weak self] in
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
        subscribeAndCallback(observable: Single<Bool>.fromAsync { [weak self] in
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
        subscribeAndCallback(observable: Single<Bool>.fromAsync { [weak self] in
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
        subscribeAndCallback(observable: Single<Bool>.fromAsync { [weak self] in
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
        subscribeAndCallback(observable: Single<Bool>.fromAsync { [weak self] in
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
        subscribeAndCallback(observable: Single<Bool>.fromAsync { [weak self] in
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
        subscribeAndCallback(observable: Single<Bool>.fromAsync { [weak self] in
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
        subscribeAndCallback(observable: Single<Bool>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.evm.signTypedDataUnique(message, chainInfo: chainInfo)
        }, callback: callback)
    }

    func evmSendTransaction(_ transaction: String?, callback: @escaping ParticleCallback) {
        guard let transaction = transaction else { callback(getErrorJson("json is nil"))
            return
        }
        let chainInfo = ParticleNetwork.getChainInfo()
        subscribeAndCallback(observable: Single<Bool>.fromAsync { [weak self] in
            guard let self = self else {
                throw ParticleNetwork.ResponseError(code: nil, message: "self is nil")
            }
            return try await self.auth.evm.sendTransaction(transaction, chainInfo: chainInfo)
        }, callback: callback)
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
