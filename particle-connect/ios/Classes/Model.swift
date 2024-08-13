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
    func ResponseFromError(_ error: Error) -> PNResponseError {
        if let responseError = error as? ParticleNetwork.ResponseError {
            return PNResponseError(code: responseError.code, message: responseError.message ?? "", data: responseError.data)
        } else if let error = error as? ConnectError {
            return PNResponseError(code: error.code, message: error.message!, data: nil)
        } else {
            return PNResponseError(code: nil, message: String(describing: error), data: nil)
        }
    }

    func map2ConnectAdapter(from walletType: WalletType) -> ConnectAdapter? {
        let adapters = ParticleConnect.getAllAdapters().filter {
            $0.walletType == walletType
        }
        let adapter = adapters.first
        return adapter
    }
}

struct PNResponseError: Codable {
    let code: Int?
    let message: String?
    let data: String?
}

struct PNStatusModel<T: Codable>: Codable {
    let status: Bool
    let data: T
}

struct PNConnectLoginResult: Codable {
    let message: String
    let signature: String
}
