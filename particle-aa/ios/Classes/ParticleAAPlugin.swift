//
//  ParticleAAPlugin.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

import Flutter
import Foundation
import ParticleAA
import ParticleNetworkBase
import RxSwift
import SwiftyJSON

public typealias ParticleCallback = FlutterResult

public class ParticleAAPlugin: NSObject, FlutterPlugin {
    let bag = DisposeBag()
    
    let aaService = AAService()
    
    public enum Method: String {
        case initialize
        case isDeploy
        case isAAModeEnable
        case enableAAMode
        case disableAAMode
        case rpcGetFeeQuotes
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "aa_bridge", binaryMessenger: registrar.messenger())
        
        let instance = ParticleAAPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = ParticleAAPlugin.Method(rawValue: call.method) else {
            result(FlutterMethodNotImplemented)
            return
        }
        
        let json = call.arguments
        
        switch method {
        case .initialize:
            initialize(json as? String)
        case .isDeploy:
            isDeploy(json as? String, callback: result)
        case .isAAModeEnable:
            isAAModeEnable(result)
        case .enableAAMode:
            enableAAMode()
        case .disableAAMode:
            disableAAMode()
        case .rpcGetFeeQuotes:
            rpcGetFeeQuotes(json as? String, callback: result)
        }
    }
}

// MARK: -  Methods

public extension ParticleAAPlugin {
    func initialize(_ json: String?) {
        guard let json = json else {
            return
        }
        
        let data = JSON(parseJSON: json)
        
        let biconomyAppKeysDict = data["biconomy_app_keys"].dictionaryValue
        var biconomyAppKeys: [Int: String] = [:]
        
        for (key, value) in biconomyAppKeysDict {
            if let chainId = Int(key) {
                biconomyAppKeys[chainId] = value.stringValue
            }
        }
        
        let accountName = AA.AccountName(rawValue: data["name"].stringValue.uppercased()) ?? .biconomy
        
        let version = AA.VersionNumber(rawValue: data["version"].stringValue.uppercased()) ?? .v1_0_0
        
        AAService.initialize(name: accountName, version: version, biconomyApiKeys: biconomyAppKeys)
        ParticleNetwork.setAAService(aaService)
    }
    
    func isDeploy(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else {
            callback(getErrorJson("json is nil"))
            return
        }
        let eoaAddress = json
        let chainInfo = ParticleNetwork.getChainInfo()
        subscribeAndCallback(observable: aaService.isDeploy(eoaAddress: eoaAddress, chainInfo: chainInfo), callback: callback)
    }
    
    func isAAModeEnable(_ callback: ParticleCallback) {
        let result = aaService.isAAModeEnable()
        callback(result)
    }
    
    func enableAAMode() {
        aaService.enableAAMode()
    }
    
    func disableAAMode() {
        aaService.disableAAMode()
    }
    
    func rpcGetFeeQuotes(_ json: String?, callback: @escaping ParticleCallback) {
        guard let json = json else {
            callback(getErrorJson("json is nil"))
            return
        }
        
        let data = JSON(parseJSON: json)
        let eoaAddress = data["eoa_address"].stringValue
        let transactions = data["transactions"].arrayValue.map {
            $0.stringValue
        }
        let chainInfo = ParticleNetwork.getChainInfo()
        subscribeAndCallback(observable: aaService.rpcGetFeeQuotes(eoaAddress: eoaAddress, transactions: transactions, chainInfo: chainInfo), callback: callback)
    }
}

extension ParticleAAPlugin {
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
        }.disposed(by: bag)
    }
}

extension ParticleAAPlugin {
    private func getErrorJson(_ message: String) -> String {
        let response = FlutterResponseError(code: nil, message: message, data: nil)
        let statusModel = FlutterStatusModel(status: false, data: response)
        let data1 = try! JSONEncoder().encode(statusModel)
        guard let json = String(data: data1, encoding: .utf8) else { return "" }
        return json
    }
}
