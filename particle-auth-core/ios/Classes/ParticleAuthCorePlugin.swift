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
import Base58_swift

public class ParticleAuthCorePlugin: NSObject, FlutterPlugin {
    let auth = Auth()

    let bag = DisposeBag()

    public enum Method: String {
        case initialize
        case connect
        case getUserInfo
        case disconnect
        case isConnected
        case evmGetAddress
        case solanaGetAddress
        case switchChain
        case evmPersonalSign
        case evmPersonalSignUnique
        case evmSignTypedData
        case evmSignTypedDataUnique
        case evmSendTransaction
        case solanaSignMessage
        case solanaSignTransaction
        case solanaSignAllTransactions
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "auth_core_bridge", binaryMessenger: registrar.messenger())
        
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
            case .connect:
                self.connect(json as? String, flutterResult: result)
            case .disconnect:
                self.disconnect(flutterResult: result)
            case .isConnected:
                self.isConnected(flutterResult: result)
            case .getUserInfo:
                self.getUserInfo(flutterResult: result)
            case .switchChain:
                self.switchChain(json as? Int, flutterResult: result)
            case .evmGetAddress:
                self.evmGetAddress(flutterResult: result)
            case .solanaGetAddress:
                self.solanaGetAddress(flutterResult: result)
            case .evmPersonalSign:
                self.evmPersonalSign(json as? String, flutterResult: result)
            case .evmPersonalSignUnique:
                self.evmPersonalSignUnique(json as? String, flutterResult: result)
            case .evmSignTypedData:
                self.evmSignTypedData(json as? String, flutterResult: result)
            case .evmSignTypedDataUnique:
                self.evmSignTypedDataUnique(json as? String, flutterResult: result)
            case .evmSendTransaction:
                self.evmSendTransaction(json as? String, flutterResult: result)
            case .solanaSignMessage:
                self.solanaSignMessage(json as? String, flutterResult: result)
            case .solanaSignTransaction:
                self.solanaSignTransaction(json as? String, flutterResult: result)
            case .solanaSignAllTransactions:
                self.solanaSignAllTransactions(json as? String, flutterResult: result)
            case .solanaSignAndSendTransaction:
                self.solanaSignAndSendTransaction(json as? String, flutterResult: result)
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

    func connect(_ json: String?, flutterResult: @escaping FlutterResult) {
        let jwt = json ?? ""
        Task {
            do {
                let userInfo = try await auth.connect(jwt: jwt)
                let userInfoJsonString = userInfo.jsonStringFullSnake()
                let newUserInfo = JSON(parseJSON: userInfoJsonString)
                let statusModel = FlutterStatusModel(status: true, data: newUserInfo)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json ?? "")
            } catch {
                let response = self.ResponseFromError(error)
                let statusModel = FlutterStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                flutterResult(json ?? "")
            }
        }
    }

    func getUserInfo(flutterResult: @escaping FlutterResult) {
        guard let userInfo = auth.getUserInfo() else {
            flutterResult(FlutterError(code: "", message: "user is not login", details: nil))
            return
        }
        
        let userInfoJsonString = userInfo.jsonStringFullSnake()
        let newUserInfo = JSON(parseJSON: userInfoJsonString)
        
        let data = try! JSONEncoder().encode(newUserInfo)
        let json = String(data: data, encoding: .utf8)
        flutterResult(json ?? "")
    }

    func disconnect(flutterResult: @escaping FlutterResult) {
        Task {
            do {
                let result = try await auth.disconnect()
                flutterResult(result)
            } catch {
                print(error)
                flutterResult(false)
            }
        }
    }

    func isConnected(flutterResult: @escaping FlutterResult) {
        Task {
            do {
                let result = try await auth.isConnected()
                flutterResult(result)
            } catch {
                print(error)
                flutterResult(false)
            }
        }
    }

    func switchChain(_ json: Int?, flutterResult: @escaping FlutterResult) {
        let chainId = json ?? 0
        Task {
            do {
                guard let chainInfo = ParticleNetwork.searchChainInfo(by: chainId) else {
                    return print("initialize error, can't find right chainId \(chainId)")
                }
                let result = try await auth.switchChain(chainInfo: chainInfo)
                flutterResult(result)
            } catch {
                print(error)
                flutterResult(false)
            }
        }
    }

    func evmGetAddress(flutterResult: @escaping FlutterResult) {
        let result: String? = auth.evm.getAddress()

        flutterResult(result ?? "")
    }

    func solanaGetAddress(flutterResult: @escaping FlutterResult) {
        let result: String? = auth.solana.getAddress()

        flutterResult(result ?? "")
    }

    func evmPersonalSign(_ json: String?, flutterResult: @escaping FlutterResult) {
        let messageHex = json ?? ""
        
        Task {
            do {
                let signature = try await auth.evm.personalSign(messageHex)
                flutterResult(signature)
            } catch {
                print(error)
                flutterResult("")
            }
        }
    }
    
    func evmPersonalSignUnique(_ json: String?, flutterResult: @escaping FlutterResult) {
        let messageHex = json ?? ""
        
        Task {
            do {
                let signature = try await auth.evm.personalSignUnique(messageHex)
                flutterResult(signature)
            } catch {
                print(error)
                flutterResult("")
            }
        }
    }
    
    func evmSignTypedData(_ json: String?, flutterResult: @escaping FlutterResult) {
        let typedDataV4 = json ?? ""
        
        Task {
            do {
                let signature = try await auth.evm.signTypedData(typedDataV4)
                flutterResult(signature)
            } catch {
                print(error)
                flutterResult("")
            }
        }
    }

    func evmSignTypedDataUnique(_ json: String?, flutterResult: @escaping FlutterResult) {
        let typedDataV4 = json ?? ""
        
        Task {
            do {
                let signature = try await auth.evm.signTypedDataUnique(typedDataV4)
                flutterResult(signature)
            } catch {
                print(error)
                flutterResult("")
            }
        }
    }
    
    func evmSendTransaction(_ json: String?, flutterResult: @escaping FlutterResult) {
        let transaction = json ?? ""
        
        Task {
            do {
                let signature = try await auth.evm.sendTransaction(transaction)
                flutterResult(signature)
            } catch {
                print(error)
                flutterResult("")
            }
        }
    }

    func solanaSignMessage(_ message: String?, flutterResult: @escaping FlutterResult) {
        // let serializedMessage = Base58.encode(message.data(using: .utf8)!)

        // Task {
        //     do {
        //         let signature = try await auth.solana.signMessage(serializedMessage)
        //         let statusModel = FlutterStatusModel(status: true, data: signature)
        //         let data = try! JSONEncoder().encode(statusModel)
        //         guard let json = String(data: data, encoding: .utf8) else { return }
        //         flutterResult(json)
        //     } catch {
        //         let response = self.ResponseFromError(error)
        //         let statusModel = FlutterStatusModel(status: false, data: response)
        //         let data = try! JSONEncoder().encode(statusModel)
        //         guard let json = String(data: data, encoding: .utf8) else { return }
        //         flutterResult(json)
        //     }
        // }
    }

    func solanaSignTransaction(_ message: String?, flutterResult: @escaping FlutterResult) {

    }
    
    func solanaSignAllTransactions(_ message: String?, flutterResult: @escaping FlutterResult) {

    }
    
    func solanaSignAndSendTransaction(_ message: String?, flutterResult: @escaping FlutterResult) {

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
