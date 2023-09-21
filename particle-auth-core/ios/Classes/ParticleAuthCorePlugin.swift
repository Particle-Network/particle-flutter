//
//  ParticleAuthCorePlugin.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

import ParticleAuthCore
import Flutter
import RxSwift

public class ParticleAuthCorePlugin: NSObject, FlutterPlugin {
    let bag = DisposeBag()
    
    public enum Method: String {
        case initialize
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        // let channel = FlutterMethodChannel(name: "auth_core_bridge", binaryMessenger: registrar.messenger())
        
        // let instance = ParticleAuthCore()
        
        // channel.invokeMethod(Method.initialize.rawValue, arguments: nil)

        // registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    }
}
