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
import ParticleNetworkChains
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
        case sendPhoneCode
        case sendEmailCode
        case connectWithCode

        var containsParameter: Bool {
            switch self {
            case .connect, .switchChain, .evmPersonalSign, .evmSignTypedData, .evmPersonalSignUnique, .evmSignTypedDataUnique, .evmSendTransaction, .solanaSignMessage, .solanaSignTransaction, .solanaSignAllTransactions, .solanaSignAndSendTransaction,
                 .sendEmailCode, .sendPhoneCode, .connectWithCode, .evmBatchSendTransactions, .setBlindEnable:
                return true

            case .initialize, .disconnect, .isConnected, .solanaGetAddress, .evmGetAddress, .getUserInfo, .getBlindEnable, .openAccountAndSecurity, .hasMasterPassword, .hasPaymentPassword, .changeMasterPassword:
                return false
            }
        }
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

        if method.containsParameter, (json as? String?) == nil, (json as? Bool) == nil {
            let response = ParticleNetwork.ResponseError(code: nil, message: "parameters is required")
            let statusModel = PNStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            result(json)
        }

        switch method {
        case .initialize:
            ShareAuthCore.shared.initialize()
        case .switchChain:
            ShareAuthCore.shared.switchChain(json as! String, callback: result)
        case .connect:
            ShareAuthCore.shared.connect(json as! String, callback: result)
        case .disconnect:
            ShareAuthCore.shared.disconnect(result)
        case .isConnected:
            ShareAuthCore.shared.isConnected(result)
        case .solanaSignMessage:
            ShareAuthCore.shared.solanaSignMessage(json as! String, callback: result)
        case .solanaSignTransaction:
            ShareAuthCore.shared.solanaSignTransaction(json as! String, callback: result)
        case .solanaSignAllTransactions:
            ShareAuthCore.shared.solanaSignAllTransactions(json as! String, callback: result)
        case .solanaSignAndSendTransaction:
            ShareAuthCore.shared.solanaSignAndSendTransaction(json as! String, callback: result)
        case .evmPersonalSign:
            ShareAuthCore.shared.evmPersonalSign(json as! String, callback: result)
        case .evmPersonalSignUnique:
            ShareAuthCore.shared.evmPersonalSignUnique(json as! String, callback: result)
        case .evmSignTypedData:
            ShareAuthCore.shared.evmSignTypedData(json as! String, callback: result)
        case .evmSignTypedDataUnique:
            ShareAuthCore.shared.evmSignTypedDataUnique(json as! String, callback: result)
        case .evmSendTransaction:
            ShareAuthCore.shared.evmSendTransaction(json as! String, callback: result)
        case .evmBatchSendTransactions:
            ShareAuthCore.shared.evmBatchSendTransactions(json as! String, callback: result)
        case .solanaGetAddress:
            let value = ShareAuthCore.shared.solanaGetAddress()
            result(value)
        case .evmGetAddress:
            let value = ShareAuthCore.shared.evmGetAddress()
            result(value)
        case .getUserInfo:
            let value = ShareAuthCore.shared.getUserInfo()
            result(value)
        case .openAccountAndSecurity:
            ShareAuthCore.shared.openAccountAndSecurity(result)
        case .hasPaymentPassword:
            ShareAuthCore.shared.hasPaymentPassword(result)
        case .hasMasterPassword:
            ShareAuthCore.shared.hasMasterPassword(result)
        case .changeMasterPassword:
            ShareAuthCore.shared.changeMasterPassword(result)
        case .setBlindEnable:
            ShareAuthCore.shared.setBlindEnable(json as! Bool)
        case .getBlindEnable:
            let value = ShareAuthCore.shared.getBlindEnable()
            result(value)
        case .sendEmailCode:
            ShareAuthCore.shared.sendEmailCode(json as! String, callback: result)
        case .sendPhoneCode:
            ShareAuthCore.shared.sendPhoneCode(json as! String, callback: result)
        case .connectWithCode:
            ShareAuthCore.shared.connectWithCode(json as! String, callback: result)
        }
    }
}

extension ParticleAuthCorePlugin {
    private func getErrorJson(_ message: String) -> String {
        let response = PNResponseError(code: nil, message: message, data: nil)
        let statusModel = PNStatusModel(status: false, data: response)
        let data = try! JSONEncoder().encode(statusModel)
        guard let json = String(data: data, encoding: .utf8) else { return "" }
        return json
    }
}
