//
//  ParticleBiconomyPlugin.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

import Flutter
import Foundation
import ParticleBiconomy
import ParticleNetworkBase
import RxSwift
import SwiftyJSON

public class ParticleBiconomyPlugin: NSObject, FlutterPlugin {
    let bag = DisposeBag()
    
    let biconomy = BiconomyService()
    
    public enum Method: String {
        case initialize
        case isSupportChainInfo
        case isDeploy
        case isBiconomyModeEnable
        case enableBiconomyMode
        case disableBiconomyMode
        case rpcGetFeeQuotes
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "biconomy_bridge", binaryMessenger: registrar.messenger())
        
        let instance = ParticleBiconomyPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = ParticleBiconomyPlugin.Method(rawValue: call.method) else {
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
        case .isBiconomyModeEnable:
            isBiconomyModeEnable(flutterResult: result)
        case .enableBiconomyMode:
            enableBiconomyMode()
        case .disableBiconomyMode:
            disableBiconomyMode()
        case .rpcGetFeeQuotes:
            rpcGetFeeQuotes(json as? String, flutterResult: result)
        }
    }
}

// MARK: -  Methods

public extension ParticleBiconomyPlugin {
    func initialize(_ json: String?) {
        guard let json = json else {
            return
        }
        
        let data = JSON(parseJSON: json)
        let version = data["version"].stringValue.lowercased()
        let dappAppKeysDict = data["dapp_app_keys"].dictionaryValue
        var dappAppKeys: [Int: String] = [:]
        
        for (key, value) in dappAppKeysDict {
            if let chainId = Int(key) {
                dappAppKeys[chainId] = value.stringValue
            }
        }
        
        BiconomyService.initialize(version: .init(rawValue: version) ?? .v1_0_0, dappApiKeys: dappAppKeys)
        ParticleNetwork.setBiconomyService(self.biconomy)
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
        let result = biconomy.isSupportChainInfo(chainInfo)
        flutterResult(result)
    }

    func isDeploy(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else { return }
        let eoaAddress = json
        
        biconomy.isDeploy(eoaAddress: eoaAddress).subscribe {
            [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let flag):
                    let statusModel = FlutterStatusModel(status: true, data: flag)
                    let data = try! JSONEncoder().encode(statusModel)
                    guard let json = String(data: data, encoding: .utf8) else { return }
                    flutterResult(json)
                case .failure(let error):
                    let response = self.ResponseFromError(error)
                    let statusModel = FlutterStatusModel(status: false, data: response)
                    let data = try! JSONEncoder().encode(statusModel)
                    guard let json = String(data: data, encoding: .utf8) else { return }
                    flutterResult(json)
                }
        }.disposed(by: bag)
    }
    
    func isBiconomyModeEnable(flutterResult: FlutterResult) {
        let result = biconomy.isBiconomyModeEnable()
        flutterResult(result)
    }
    
    func enableBiconomyMode() {
        biconomy.enableBiconomyMode()
    }
    
    func disableBiconomyMode() {
        biconomy.disableBiconomyMode()
    }
    
    func rpcGetFeeQuotes(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else { return }
        
        let data = JSON(parseJSON: json)
        let eoaAddress = data["eoa_address"].stringValue
        let transactions = data["transactions"].arrayValue.map {
            $0.stringValue
        }
        
        biconomy.rpcGetFeeQuotes(eoaAddress: eoaAddress, transactions: transactions).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let quotes):
                let feeQuotes = quotes.map {
                    $0.jsonObject
                }
                let statusModel = FlutterStatusModel(status: true, data: feeQuotes)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            }
        }.disposed(by: bag)
    }
}

