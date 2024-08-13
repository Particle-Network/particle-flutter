//
//  Model.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

import Foundation
import ParticleNetworkBase

extension NSObject {
    func ResponseFromError(_ error: Error) -> PNResponseError {
        if let responseError = error as? ParticleNetwork.ResponseError {
            return PNResponseError(code: responseError.code, message: responseError.message ?? "", data: responseError.data)
        } else {
            return PNResponseError(code: nil, message: String(describing: error), data: nil)
        }
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
