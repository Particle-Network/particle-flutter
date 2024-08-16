//
//  ParticleConnectPlugin.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

import Flutter
import ParticleNetworkBase

public class ParticleConnectPlugin: NSObject, FlutterPlugin {
    var eventSink: FlutterEventSink?
    
    public enum Method: String {
        case initialize
        case getAccounts
        case connect
        case connectWithConnectKitConfig
        case disconnect
        case isConnected
        case signMessage
        case signTransaction
        case signAllTransactions
        case signAndSendTransaction
        case signTypedData
        case signInWithEthereum
        case verify
        case importPrivateKey
        case importMnemonic
        case exportPrivateKey
        case walletReadyState
        case connectWalletConnect
        case batchSendTransactions
        case setWalletConnectV2SupportChainInfos
        
        var containsParameter: Bool {
            switch self {
            case .initialize,
                 .getAccounts,
                 .connect,
                 .connectWithConnectKitConfig,
                 .disconnect,
                 .isConnected,
                 .signMessage,
                 .signTransaction,
                 .signAllTransactions,
                 .signAndSendTransaction,
                 .signTypedData,
                 .signInWithEthereum,
                 .verify,
                 .importPrivateKey,
                 .importMnemonic,
                 .exportPrivateKey,
                 .walletReadyState,
                 .batchSendTransactions,
                 .setWalletConnectV2SupportChainInfos:
                return true
            case .connectWalletConnect:
                return false
            }
        }
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "connect_bridge", binaryMessenger: registrar.messenger())
        
        let instance = ParticleConnectPlugin()
        
        let eventChannel = FlutterEventChannel(name: "connect_event_bridge", binaryMessenger: registrar.messenger())
        
        eventChannel.setStreamHandler(instance)
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = Method(rawValue: call.method) else {
            result(FlutterMethodNotImplemented)
            return
        }
            
        let json = call.arguments
            
        if method.containsParameter, (json as! String?) == nil, (json as? Bool) == nil {
            let response = ParticleNetwork.ResponseError(code: nil, message: "parameters is required")
            let statusModel = PNStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            result(json)
        }
        
        switch method {
        case .initialize:
            ShareConnect.shared.initialize(json as! String)
        case .getAccounts:
            let value = ShareConnect.shared.getAccounts(json as! String)
            result(value)
        case .connect:
            ShareConnect.shared.connect(json as! String, callback: result)
        case .disconnect:
            ShareConnect.shared.disconnect(json as! String, callback: result)
        case .isConnected:
            ShareConnect.shared.isConnected(json as! String, callback: result)
        case .signMessage:
            ShareConnect.shared.signMessage(json as! String, callback: result)
        case .signTransaction:
            ShareConnect.shared.signTransaction(json as! String, callback: result)
        case .signAllTransactions:
            ShareConnect.shared.signAllTransactions(json as! String, callback: result)
        case .signAndSendTransaction:
            ShareConnect.shared.signAndSendTransaction(json as! String, callback: result)
        case .signTypedData:
            ShareConnect.shared.signTypedData(json as! String, callback: result)
        case .signInWithEthereum:
            ShareConnect.shared.signInWithEthereum(json as! String, callback: result)
        case .verify:
            ShareConnect.shared.verify(json as! String, callback: result)
        case .importPrivateKey:
            ShareConnect.shared.importPrivateKey(json as! String, callback: result)
        case .importMnemonic:
            ShareConnect.shared.importMnemonic(json as! String, callback: result)
        case .exportPrivateKey:
            ShareConnect.shared.exportPrivateKey(json as! String, callback: result)
        case .walletReadyState:
            ShareConnect.shared.walletReadyState(json as! String, callback: result)
        case .connectWalletConnect:
            ShareConnect.shared.connectWalletConnect(callback: result) { [weak self] uri in
                self?.eventSink?(uri)
            }
        case .batchSendTransactions:
            ShareConnect.shared.batchSendTransactions(json as! String, callback: result)
        case .setWalletConnectV2SupportChainInfos:
            ShareConnect.shared.setWalletConnectV2SupportChainInfos(json as! String)
        case .connectWithConnectKitConfig:
            ShareConnect.shared.connectWithConnectKitConfig(json as! String, callback: result)
        }
    }
}

extension ParticleConnectPlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
