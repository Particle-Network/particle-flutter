//
//  ParticleWalletPlugin.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

import Flutter
import ParticleNetworkBase

public class ParticleWalletPlugin: NSObject, FlutterPlugin {
    public enum Method: String {
        case navigatorWallet
        case navigatorTokenReceive
        case navigatorTokenSend
        case navigatorTokenTransactionRecords
        case navigatorNFTSend
        case navigatorNFTDetails
        case navigatorBuyCrypto
        case navigatorSwap
        case navigatorDappBrowser
        case setShowTestNetwork
        case setShowManageWallet
        case setSupportChain
        case setPayDisabled
        case getPayDisabled
        case setSwapDisabled
        case getSwapDisabled
        case setBridgeDisabled
        case getBridgeDisabled
        case switchWallet
        case setSupportDappBrowser
        case setShowLanguageSetting
        case setShowAppearanceSetting
        case setShowSmartAccountSetting
        case setSupportAddToken
        case setDisplayTokenAddresses
        case setDisplayNFTContractAddresses
        case setPriorityTokenAddresses
        case setPriorityNFTContractAddresses
        case setSupportWalletConnect
        case initializeWalletMetaData
        case setCustomWalletName
        case setCustomLocalizable
        case setWalletConnectProjectId

        var containsParameter: Bool {
            switch self {
            case .navigatorWallet,
                 .navigatorTokenReceive,
                 .navigatorTokenSend,
                 .navigatorTokenTransactionRecords,
                 .navigatorNFTSend,
                 .navigatorNFTDetails,
                 .navigatorBuyCrypto,
                 .navigatorSwap,
                 .navigatorDappBrowser,
                 .setShowTestNetwork,
                 .setShowManageWallet,
                 .setSupportChain,
                 .setPayDisabled,
                 .setSwapDisabled,
                 .setBridgeDisabled,
                 .switchWallet,
                 .setSupportDappBrowser,
                 .setShowLanguageSetting,
                 .setShowAppearanceSetting,
                 .setShowSmartAccountSetting,
                 .setSupportAddToken,
                 .setDisplayTokenAddresses,
                 .setDisplayNFTContractAddresses,
                 .setPriorityTokenAddresses,
                 .setPriorityNFTContractAddresses,
                 .setSupportWalletConnect,
                 .initializeWalletMetaData,
                 .setCustomWalletName,
                 .setCustomLocalizable,
                 .setWalletConnectProjectId:
                return true
            case .getPayDisabled, .getSwapDisabled, .getBridgeDisabled:
                return false
            }
        }
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "wallet_bridge", binaryMessenger: registrar.messenger())

        let instance = ParticleWalletPlugin()

        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = Method(rawValue: call.method) else {
            result(FlutterMethodNotImplemented)
            return
        }

        let json = call.arguments

        if method.containsParameter, (json as? String?) == nil, (json as? Bool) == nil, (json as? Int) == nil {
            let response = ParticleNetwork.ResponseError(code: nil, message: "parameters is required")
            let statusModel = PNStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            result(json)
        }

        switch method {
        case .navigatorWallet:
            ShareWallet.shared.navigatorWallet(json as! Int)
        case .navigatorTokenReceive:
            ShareWallet.shared.navigatorTokenReceive(json as! String)
        case .navigatorTokenSend:
            ShareWallet.shared.navigatorTokenSend(json as! String)
        case .navigatorTokenTransactionRecords:
            ShareWallet.shared.navigatorTokenTransactionRecords(json as! String)
        case .navigatorNFTSend:
            ShareWallet.shared.navigatorNFTSend(json as! String)
        case .navigatorNFTDetails:
            ShareWallet.shared.navigatorNFTDetails(json as! String)
        case .navigatorBuyCrypto:
            ShareWallet.shared.navigatorBuyCrypto(json as! String)

        case .navigatorSwap:
            ShareWallet.shared.navigatorSwap(json as! String)
        case .navigatorDappBrowser:
            ShareWallet.shared.navigatorDappBrowser(json as! String)
        case .setShowTestNetwork:
            ShareWallet.shared.setShowTestNetwork(json as! Bool)
        case .setShowSmartAccountSetting:
            ShareWallet.shared.setShowSmartAccountSetting(json as! Bool)
        case .setShowManageWallet:
            ShareWallet.shared.setShowManageWallet(json as! Bool)
        case .setSupportChain:
            ShareWallet.shared.setSupportChain(json as! String)
        case .setPayDisabled:
            ShareWallet.shared.setPayDisabled(json as! Bool)
        case .getPayDisabled:
            let value = ShareWallet.shared.getPayDisabled()
            result(value)
        case .setSwapDisabled:
            ShareWallet.shared.setSwapDisabled(json as! Bool)
        case .getSwapDisabled:
            let value = ShareWallet.shared.getSwapDisabled()
            result(value)
        case .setBridgeDisabled:
            ShareWallet.shared.setBridgeDisabled(json as! Bool)
        case .getBridgeDisabled:
            let value = ShareWallet.shared.getBridgeDisabled()
            result(value)
        case .switchWallet:
            let value = ShareWallet.shared.switchWallet(json as! String)
            result(value)
        case .setSupportWalletConnect:
            ShareWallet.shared.setSupportWalletConnect(json as! Bool)
        case .setSupportDappBrowser:
            ShareWallet.shared.setSupportDappBrowser(json as! Bool)
        case .setShowLanguageSetting:
            ShareWallet.shared.setShowLanguageSetting(json as! Bool)
        case .setShowAppearanceSetting:
            ShareWallet.shared.setShowAppearanceSetting(json as! Bool)
        case .setSupportAddToken:
            ShareWallet.shared.setSupportAddToken(json as! Bool)
        case .setDisplayTokenAddresses:
            ShareWallet.shared.setDisplayTokenAddresses(json as! String)
        case .setDisplayNFTContractAddresses:
            ShareWallet.shared.setDisplayNFTContractAddresses(json as! String)
        case .setPriorityTokenAddresses:
            ShareWallet.shared.setPriorityTokenAddresses(json as! String)
        case .setPriorityNFTContractAddresses:
            ShareWallet.shared.setPriorityNFTContractAddresses(json as! String)
        case .initializeWalletMetaData:
            ShareWallet.shared.initializeWalletMetaData(json as! String)
        case .setCustomWalletName:
            ShareWallet.shared.setCustomWalletName(json as! String)
        case .setCustomLocalizable:
            ShareWallet.shared.setCustomLocalizable(json as! String)
        case .setWalletConnectProjectId:
            ShareWallet.shared.setWalletConnectProjectId(json as! String)
        }
    }
}

// MARK: -  Methods

extension ParticleWalletPlugin {
    private func getErrorJson(_ message: String) -> String {
        let response = PNResponseError(code: nil, message: message, data: nil)
        let statusModel = PNStatusModel(status: false, data: response)
        let data1 = try! JSONEncoder().encode(statusModel)
        guard let json = String(data: data1, encoding: .utf8) else { return "" }
        return json
    }
}
