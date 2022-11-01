//
//  ParticleAuthPlugin.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

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
        case signMessage
        case signTransaction
        case signAllTransactions
        case signAndSendTransaction
        case signTypedData
        case getAddress
        case getUserInfo
        case setModalPresentStyle
        case setDisplayWallet
        case openWebWallet
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
            self.setChainInfo(json as? String)
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
        case .signMessage:
            self.signMessage(json as? String, flutterResult: result)
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
        case .setDisplayWallet:
            self.setDisplayWallet(json as? Bool ?? false)
        case .openWebWallet:
            self.openWebWallet()
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
        guard let chainName = matchChain(name: name, chainId: chainId) else {
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
        
        let config = ParticleNetworkConfiguration(chainInfo: chainName, devEnv: devEnv)
        ParticleNetwork.initialize(config: config)
    }
    
    func setChainInfo(_ json: String?) {
        guard let json = json else {
            return
        }
        
        let data = JSON(parseJSON: json)
        let name = data["chain_name"].stringValue.lowercased()
        let chainId = data["chain_id"].intValue
        guard let chainInfo = matchChain(name: name, chainId: chainId) else { return }
        ParticleNetwork.setChainInfo(chainInfo)
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
        let loginFormMode = data["login_form_mode"].bool ?? false
        
        let loginType = LoginType(rawValue: type) ?? .email
        var supportAuthTypeArray: [SupportAuthType] = []
        
        let array = supportAuthType.map {
            $0.stringValue.lowercased()
        }
        
        if array.contains("all") {
            supportAuthTypeArray = [.all]
        } else {
            array.forEach {
                if $0 == "apple" {
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
                }
            }
        }
        
        var acc = account
        if acc != nil, acc!.isEmpty {
            acc = nil
        }
        
        ParticleAuthService.login(type: loginType, account: acc, supportAuthType: supportAuthTypeArray, loginFormMode: loginFormMode).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            case .success(let userInfo):
                guard let userInfo = userInfo else { return }
                let statusModel = FlutterStatusModel(status: true, data: userInfo)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            }
        }.disposed(by: self.bag)
    }
    
    func logout(flutterResult: @escaping FlutterResult) {
        ParticleAuthService.logout().subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            case .success(let success):
                let statusModel = FlutterStatusModel(status: true, data: success)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            }
        }.disposed(by: self.bag)
    }
    
    func isLogin(flutterResult: @escaping FlutterResult) {
        flutterResult(ParticleAuthService.isLogin())
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
            serializedMessage = "0x" + message.data(using: .utf8)!.map { String(format: "%02x", $0) }.joined()
        }
        
        ParticleAuthService.signMessage(serializedMessage).subscribe { [weak self] result in
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
    
    func signTransaction(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let transaction = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        ParticleAuthService.signTransaction(transaction).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            case .success(let signed):
                let statusModel = FlutterStatusModel(status: true, data: signed)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            }
        }.disposed(by: self.bag)
    }
    
    func signAllTransactions(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let transactions = JSON(parseJSON: json).arrayValue.map { $0.stringValue }
        
        ParticleAuthService.signAllTransactions(transactions).subscribe { [weak self] result in
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
    
    func signAndSendTransaction(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let transaction = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        ParticleAuthService.signAndSendTransaction(transaction).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            case .success(let signature):
                let statusModel = FlutterStatusModel(status: true, data: signature)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            }
        }.disposed(by: self.bag)
    }
    
    func signTypedData(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        
        let data = JSON(parseJSON: json)
        let message = data["message"].stringValue
        let version = data["version"].stringValue.lowercased()
        
        let hexString = "0x" + message.data(using: .utf8)!.map { String(format: "%02x", $0) }.joined()
       
        ParticleAuthService.signTypedData(hexString, version: EVMSignTypedDataVersion(rawValue: version) ?? .v1).subscribe { [weak self] result in
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
    
    func getAddress(flutterResult: @escaping FlutterResult) {
        flutterResult(ParticleAuthService.getAddress())
    }
    
    func getUserInfo(flutterResult: @escaping FlutterResult) {
        guard let userInfo = ParticleAuthService.getUserInfo() else {
            flutterResult(FlutterError(code: "", message: "user is not login", details: nil))
            return
        }
        let data = try! JSONEncoder().encode(userInfo)
        let json = String(data: data, encoding: .utf8)
        flutterResult(json ?? "")
    }
    
    func setChainInfoAsync(_ json: String?, flutterResult: @escaping FlutterResult) {
        guard let json = json else {
            flutterResult(FlutterError(code: "", message: "json is nil", details: nil))
            return
        }
        let data = JSON(parseJSON: json)
        let name = data["chain_name"].stringValue.lowercased()
        let chainId = data["chain_id"].intValue
        guard let chainInfo = matchChain(name: name, chainId: chainId) else { return }
        ParticleAuthService.setChainInfo(chainInfo).subscribe { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure(let error):
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                
                flutterResult(json)
            case .success:
                let statusModel = FlutterStatusModel(status: true, data: true)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json)
            }
        }.disposed(by: self.bag)
    }
    
    func setModalPresentStyle(_ json: String?) {
        guard let style = json else {
            return
        }
        if style == "fullScreen" {
            ParticleAuthService.setModalPresentStyle(.fullScreen)
        } else {
            ParticleAuthService.setModalPresentStyle(.formSheet)
        }
    }
    
    func setInterfaceStyle(_ json: String?) {
        guard let json = json else {
            return
        }
        /**
         SYSTEM,
         LIGHT,
         DARK,
         */
        if json.lowercased() == "system" {
            ParticleAuthService.setInterfaceStyle(UIUserInterfaceStyle.unspecified)
        } else if json.lowercased() == "light" {
            ParticleAuthService.setInterfaceStyle(UIUserInterfaceStyle.light)
        } else if json.lowercased() == "dark" {
            ParticleAuthService.setInterfaceStyle(UIUserInterfaceStyle.dark)
        }
    }
    
    func setDisplayWallet(_ displayWallet: Bool) {
        ParticleAuthService.setDisplayWallet(displayWallet)
    }
    
    func openWebWallet() {
        ParticleAuthService.openWebWallet()
    }
}
