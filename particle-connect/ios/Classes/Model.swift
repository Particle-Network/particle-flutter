//
//  Model.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

import ConnectCommon
import Foundation
import ParticleConnect
import ParticleNetworkBase

extension NSObject {
    func ResponseFromError(_ error: Error) -> FlutterResponseError {
        if let responseError = error as? ParticleNetwork.ResponseError {
            return FlutterResponseError(code: responseError.code, message: responseError.message ?? "", data: responseError.data)
        } else if let error = error as? ConnectError {
            return FlutterResponseError(code: error.code, message: error.message!, data: nil)
        } else {
            return FlutterResponseError(code: nil, message: String(describing: error), data: nil)
        }
    }

    public func map2WalletType(from string: String) -> WalletType? {
        let str = string.lowercased()
        var walletType: WalletType?
        if str == "particle" {
            walletType = .particle
        } else if str == "authcore" {
            walletType = .authCore
        } else if str == "evmprivatekey" {
            walletType = .evmPrivateKey
        } else if str == "solanaprivatekey" {
            walletType = .solanaPrivateKey
        } else if str == "metamask" {
            walletType = .metaMask
        } else if str == "rainbow" {
            walletType = .rainbow
        } else if str == "trust" {
            walletType = .trust
        } else if str == "imtoken" {
            walletType = .imtoken
        } else if str == "bitkeep" {
            walletType = .bitkeep
        } else if str == "walletconnect" {
            walletType = .walletConnect
        } else if str == "phantom" {
            walletType = .phantom
        } else if str == "zerion" {
            walletType = .zerion
        } else if str == "math" {
            walletType = .math
        } else if str == "omni" {
            walletType = .omni
        } else if str == "zengo" {
            walletType = .zengo
        } else if str == "alpha" {
            walletType = .alpha
        } else if str == "okx" {
            walletType = .okx
        } else if str == "inch1" {
            walletType = .inch1
        } else {
            walletType = nil
        }

        return walletType
    }

    func map2ConnectAdapter(from walletType: WalletType) -> ConnectAdapter? {
        let adapters = ParticleConnect.getAllAdapters().filter {
            $0.walletType == walletType
        }
        let adapter = adapters.first
        return adapter
    }
}

struct FlutterResponseError: Codable {
    let code: Int?
    let message: String?
    let data: String?
}

struct FlutterStatusModel<T: Codable>: Codable {
    let status: Bool
    let data: T
}

struct FlutterConnectLoginResult: Codable {
    let message: String
    let signature: String
}

struct FlutterLoginListModel: Codable {
    let walletType: String
    let account: Account
}
