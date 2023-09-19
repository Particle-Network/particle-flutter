//
//  ParticleAuthCorePlugin.swift
//  ParticleAuthCoreExample
//
//  Created by link on 2022/9/28.
//

import Base58_swift
import Foundation
import ParticleAuthCore
import ParticleNetworkBase
import RxSwift
import SwiftyJSON
import AuthCoreAdapter
import ConnectCommon

@objc(ParticleAuthCorePlugin)
class ParticleAuthCorePlugin: NSObject {
    let bag = DisposeBag()
    let auth = Auth()
    
    @objc
    static func requiresMainQueueSetup() -> Bool {
        return true
    }

    @objc
    public func initialize(_ json: String) {
        ConnectManager.setMoreAdapters([AuthCoreAdapter()])
    }
    
    @objc
    public func switchChain(_ json: String, callback: @escaping RCTResponseSenderBlock) {
        let data = JSON(parseJSON: json)

        let chainId = data["chain_id"].intValue
        guard let chainInfo = ParticleNetwork.searchChainInfo(by: chainId) else {
            callback([false])
            return
        }
            
        Task {
            do {
                let flag = try await auth.switchChain(chainInfo: chainInfo)
                callback([flag])
            } catch {
                callback([false])
            }
        }
    }

    @objc
    public func connect(_ json: String, callback: @escaping RCTResponseSenderBlock) {
        let jwt = json
        Task {
            do {
                let userInfo = try await auth.connect(jwt: jwt)
                let userInfoJsonString = userInfo.jsonStringFullSnake()
                let newUserInfo = JSON(parseJSON: userInfoJsonString)
                let statusModel = ReactStatusModel(status: true, data: newUserInfo)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            } catch {
                let response = self.ResponseFromError(error)
                let statusModel = ReactStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            }
        }
    }
    
    @objc
    public func disconnect(_ callback: @escaping RCTResponseSenderBlock) {
        Task {
            do {
                let success = try await auth.disconnect()
                let statusModel = ReactStatusModel(status: true, data: success)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            } catch {
                let response = self.ResponseFromError(error)
                let statusModel = ReactStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            }
        }
    }

    @objc
    public func isConnected(_ callback: @escaping RCTResponseSenderBlock) {
        Task {
            do {
                let flag = try await auth.isConnected()
                let statusModel = ReactStatusModel(status: true, data: flag)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            } catch {
                let response = self.ResponseFromError(error)
                let statusModel = ReactStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            }
        }
    }
    
    @objc
    public func solanaSignMessage(_ message: String, callback: @escaping RCTResponseSenderBlock) {
        let serializedMessage = Base58.encode(message.data(using: .utf8)!)
        
        Task {
            do {
                let signature = try await auth.solana.signMessage(serializedMessage)
                let statusModel = ReactStatusModel(status: true, data: signature)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
                
            } catch {
                let response = self.ResponseFromError(error)
                let statusModel = ReactStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            }
        }
    }
    
    @objc
    public func solanaSignTransaction(_ transaction: String, callback: @escaping RCTResponseSenderBlock) {
        Task {
            do {
                let signature = try await auth.solana.signTransaction(transaction)
                let statusModel = ReactStatusModel(status: true, data: signature)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            } catch {
                let response = self.ResponseFromError(error)
                let statusModel = ReactStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            }
        }
    }
    
    @objc
    public func solanaSignAllTransactions(_ transactions: String, callback: @escaping RCTResponseSenderBlock) {
        let transactions = JSON(parseJSON: transactions).arrayValue.map { $0.stringValue }
        
        Task {
            do {
                let signatures = try await auth.solana.signAllTransactions(transactions)
                let statusModel = ReactStatusModel(status: true, data: signatures)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            } catch {
                let response = self.ResponseFromError(error)
                let statusModel = ReactStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            }
        }
    }
    
    @objc
    public func solanaSignAndSendTransaction(_ transaction: String, callback: @escaping RCTResponseSenderBlock) {
        Task {
            do {
                let signature = try await auth.solana.signAndSendTransaction(transaction)
                let statusModel = ReactStatusModel(status: true, data: signature)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            } catch {
                let response = self.ResponseFromError(error)
                let statusModel = ReactStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            }
        }
    }
    
    @objc
    public func evmPersonalSign(_ message: String, callback: @escaping RCTResponseSenderBlock) {
        Task {
            do {
                let signature = try await auth.evm.personalSign(message)
                let statusModel = ReactStatusModel(status: true, data: signature)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            } catch {
                let response = self.ResponseFromError(error)
                let statusModel = ReactStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            }
        }
    }
    
    @objc
    public func evmPersonalSignUnique(_ message: String, callback: @escaping RCTResponseSenderBlock) {
        Task {
            do {
                let signature = try await auth.evm.personalSignUnique(message)
                let statusModel = ReactStatusModel(status: true, data: signature)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            } catch {
                let response = self.ResponseFromError(error)
                let statusModel = ReactStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            }
        }
    }

    @objc
    public func evmSignTypedData(_ message: String, callback: @escaping RCTResponseSenderBlock) {
        Task {
            do {
                let signature = try await auth.evm.signTypedData(message)
                let statusModel = ReactStatusModel(status: true, data: signature)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            } catch {
                let response = self.ResponseFromError(error)
                let statusModel = ReactStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            }
        }
    }

    @objc
    public func evmSignTypedDataUnique(_ message: String, callback: @escaping RCTResponseSenderBlock) {
        Task {
            do {
                let signature = try await auth.evm.signTypedDataUnique(message)
                let statusModel = ReactStatusModel(status: true, data: signature)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            } catch {
                let response = self.ResponseFromError(error)
                let statusModel = ReactStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            }
        }
    }
    
    @objc
    public func evmSendTransaction(_ transaction: String, callback: @escaping RCTResponseSenderBlock) {
        Task {
            do {
                let signature = try await auth.evm.sendTransaction(transaction)
                let statusModel = ReactStatusModel(status: true, data: signature)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            } catch {
                let response = self.ResponseFromError(error)
                let statusModel = ReactStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            }
        }
    }
    
    @objc
    public func solanaGetAddress(_ resolve: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock) {
        let address = auth.solana.getAddress()
        resolve(address)
    }

    @objc
    public func evmGetAddress(_ resolve: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock) {
        let address = auth.evm.getAddress()
        resolve(address)
    }
    
    @objc
    public func getUserInfo(_ resolve: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock) {
        guard let userInfo = auth.getUserInfo() else {
            rejecter("", "user is not login", nil)
            return
        }

        let userInfoJsonString = userInfo.jsonStringFullSnake()
        let newUserInfo = JSON(parseJSON: userInfoJsonString)

        let data = try! JSONEncoder().encode(newUserInfo)
        let json = String(data: data, encoding: .utf8)
        resolve(json ?? "")
    }
    
    @objc
    public func openAccountAndSecurity(_ callback: @escaping RCTResponseSenderBlock) {
        Task {
            do {
                try await auth.openAccountAndSecurity()
                let null: String? = nil
                let statusModel = ReactStatusModel(status: false, data: null)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            } catch {
                let response = self.ResponseFromError(error)
                let statusModel = ReactStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback([json])
            }
        }
    }
    
    @objc
    public func openWebWallet(_ json: String) {
        auth.openWebWallet(styleJsonString: json)
    }
    
    @objc
    public func hasPaymentPassword(_ callback: @escaping RCTResponseSenderBlock) {
        do {
            let result = try auth.hasPaymentPassword()
            let statusModel = ReactStatusModel(status: false, data: result)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            callback([json])
        } catch {
            let response = ResponseFromError(error)
            let statusModel = ReactStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            callback([json])
        }
    }
    
    @objc
    public func hasMasterPassword(_ callback: @escaping RCTResponseSenderBlock) {
        do {
            let result = try auth.hasMasterPassword()
            let statusModel = ReactStatusModel(status: false, data: result)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            callback([json])
        } catch {
            let response = ResponseFromError(error)
            let statusModel = ReactStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            callback([json])
        }
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
