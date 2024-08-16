//
//  General.swift
//  particle_base
//
//  Created by link on 15/08/2024.
//

import ConnectCommon
import Foundation
import ParticleConnect
import ParticleNetworkBase

extension Dictionary {
    /// - Parameter prettify: set true to prettify string (default is false).
    /// - Returns: optional JSON String (if applicable).
    func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}

func responseFromError(_ error: Error) -> PNResponseError {
    if let responseError = error as? ParticleNetwork.ResponseError {
        return PNResponseError(code: responseError.code, message: responseError.message ?? "", data: responseError.data)
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
