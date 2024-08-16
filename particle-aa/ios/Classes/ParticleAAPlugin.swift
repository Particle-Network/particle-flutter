//
//  ParticleAAPlugin.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

import Flutter
import ParticleNetworkBase

public class ParticleAAPlugin: NSObject, FlutterPlugin {
    public enum Method: String {
        case initialize
        case isDeploy
        case isAAModeEnable
        case enableAAMode
        case disableAAMode
        case rpcGetFeeQuotes
        
        var containsParameter: Bool {
            switch self {
            case .initialize,
                 .isDeploy,
                 .rpcGetFeeQuotes:
                return true
            case .isAAModeEnable,
                 .enableAAMode,
                 .disableAAMode:
                return false
            }
        }
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
        
        if method.containsParameter, (json as! String?) == nil, (json as? Bool) == nil {
            let response = ParticleNetwork.ResponseError(code: nil, message: "parameters is required")
            let statusModel = PNStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            result(json)
        }
        
        switch method {
        case .initialize:
            ShareAA.shared.initialize(json as! String)
        case .isDeploy:
            ShareAA.shared.isDeploy(json as! String, callback: result)
        case .isAAModeEnable:
            let value = ShareAA.shared.isAAModeEnable()
            result(value)
        case .enableAAMode:
            ShareAA.shared.enableAAMode()
        case .disableAAMode:
            ShareAA.shared.disableAAMode()
        case .rpcGetFeeQuotes:
            ShareAA.shared.rpcGetFeeQuotes(json as! String, callback: result)
        }
    }
}
