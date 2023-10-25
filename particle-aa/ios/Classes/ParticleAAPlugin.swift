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

public class ParticleAAPlugin: NSObject, FlutterPlugin {
    let bag = DisposeBag()
    
    let aaService = AAService()
    
    public enum Method: String {
        case initialize
        case isSupportChainInfo
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
        case .isSupportChainInfo:
            isSupportChainInfo(json as? String, flutterResult: result)
        case .isDeploy:
            isDeploy(json as? String, flutterResult: result)
        case .isAAModeEnable:
            isAAModeEnable(flutterResult: result)
        case .enableAAMode:
            enableAAMode()
        case .disableAAMode:
            disableAAMode()
        case .rpcGetFeeQuotes:
            rpcGetFeeQuotes(json as? String, flutterResult: result)
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
        
        let dappAppKeysDict = data["dapp_app_keys"].dictionaryValue
        var dappAppKeys: [Int: String] = [:]
        
        for (key, value) in dappAppKeysDict {
            if let chainId = Int(key) {
                dappAppKeys[chainId] = value.stringValue
            }
        }
        
        AAService.initialize(dappApiKeys: dappAppKeys)
        ParticleNetwork.setAAService(aaService)
    }
    
    func isSupportChainInfo(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            return
        }
        
        let data = JSON(parseJSON: json)
        let chainId = data["chain_id"].intValue
        guard let chainInfo = ParticleNetwork.searchChainInfo(by: chainId) else {
            flutterResult(false)
            return
        }
        let result = aaService.isSupportChainInfo(chainInfo)
        flutterResult(result)
    }

    func isDeploy(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else { return }
        let eoaAddress = json
        subscribeAndCallback(observable: aaService.isDeploy(eoaAddress: eoaAddress), flutterResult: flutterResult)
    }
    
    func isAAModeEnable(flutterResult: FlutterResult) {
        let result = aaService.isAAModeEnable()
        flutterResult(result)
    }
    
    func enableAAMode() {
        aaService.enableAAMode()
    }
    
    func disableAAMode() {
        aaService.disableAAMode()
    }
    
    func rpcGetFeeQuotes(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else { return }
        
        let data = JSON(parseJSON: json)
        let eoaAddress = data["eoa_address"].stringValue
        let transactions = data["transactions"].arrayValue.map {
            $0.stringValue
        }
        
        subscribeAndCallback(observable: aaService.rpcGetFeeQuotes(eoaAddress: eoaAddress, transactions: transactions), flutterResult: flutterResult)
    }
}

extension ParticleAAPlugin {
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
        }.disposed(by: bag)
    }
}
