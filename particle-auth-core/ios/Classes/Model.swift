//
//  Model.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

import Foundation
import ParticleNetworkBase

extension NSObject {
    func ResponseFromError(_ error: Error) -> FlutterResponseError {
        if let responseError = error as? ParticleNetwork.ResponseError {
            return FlutterResponseError(code: responseError.code, message: responseError.message ?? "", data: responseError.data)
        } else {
            return FlutterResponseError(code: nil, message: String(describing: error), data: nil)
        }
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
