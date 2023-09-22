//
//  ParticleAuthCorePlugin.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

import ParticleNetworkBase
import ParticleAuthCore
import Flutter
import RxSwift
import SwiftyJSON

public class ParticleAuthCorePlugin: NSObject, FlutterPlugin {
    let bag = DisposeBag()
    
    public enum Method: String {
        case initialize
        case getUserInfo
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "auth_bridge", binaryMessenger: registrar.messenger())
        
        let instance = ParticleAuthCorePlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = ParticleAuthCorePlugin.Method(rawValue: call.method) else {
            result(FlutterMethodNotImplemented)
            return
        }
        
        let json = call.arguments
        
        switch method {
        case .initialize:
            self.initialize(json as? String)
        case .getUserInfo:
            self.getUserInfo(flutterResult: result)
        }
    }
}

// MARK: -  Methods

public extension ParticleAuthCorePlugin {
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

    func getUserInfo(flutterResult: @escaping FlutterResult) {
        flutterResult("aaa")
        return
        // let auth = Auth();
        // print("1111");
        // guard let userInfo = auth.getUserInfo() else {
        //     print("2222");
        //     flutterResult(FlutterError(code: "", message: "user is not login", details: nil))
        //     return
        // }
        
        // let userInfoJsonString = userInfo.jsonStringFullSnake()
        // let newUserInfo = JSON(parseJSON: userInfoJsonString)
        
        // let data = try! JSONEncoder().encode(newUserInfo)
        // let json = String(data: data, encoding: .utf8)
        // flutterResult(json ?? "")
    }
}

extension ParticleAuthCorePlugin {
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
