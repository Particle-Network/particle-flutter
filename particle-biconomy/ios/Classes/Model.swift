//
//  Model.swift
//  Runner
//
//  Created by link on 2022/10/8.
//

import Foundation
import ParticleNetworkBase

extension NSObject {
    func matchChain(name: String, chainId: Int) -> ParticleNetwork.ChainInfo? {
        return ParticleNetwork.searchChainInfo(by: chainId)
    }

    func matchChain(name: String) -> ParticleNetwork.Chain? {
        var chain: ParticleNetwork.Chain?

        if name == "solana" {
            chain = .solana
        } else if name == "ethereum" {
            chain = .ethereum
        } else if name == "bsc" {
            chain = .bsc
        } else if name == "polygon" {
            chain = .polygon
        } else if name == "avalanche" {
            chain = .avalanche
        } else if name == "fantom" {
            chain = .fantom
        } else if name == "arbitrum" {
            chain = .arbitrum
        } else if name == "moonbeam" {
            chain = .moonbeam
        } else if name == "moonriver" {
            chain = .moonriver
        } else if name == "heco" {
            chain = .heco
        } else if name == "aurora" {
            chain = .aurora
        } else if name == "harmony" {
            chain = .harmony
        } else if name == "kcc" {
            chain = .kcc
        } else if name == "optimism" {
            chain = .optimism
        } else if name == "platon" {
            chain = .platON
        } else if name == "tron" {
            chain = .tron
        } else if name == "okc" {
            chain = .okc
        } else if name == "thundercore" {
            chain = .thunderCore
        } else if name == "cronos" {
            chain = .cronos
        } else if name == "oasisemerald" {
            chain = .oasisEmerald
        } else if name == "gnosis" {
            chain = .gnosis
        } else if name == "celo" {
            chain = .celo
        } else if name == "klaytn" {
            chain = .klaytn
        } else if name == "scroll" {
            chain = .scroll
        } else if name == "zksync" {
            chain = .zkSync
        } else if name == "metis" {
            chain = .metis
        } else if name == "confluxespace" {
            chain = .confluxESpace
        } else if name == "mapo" {
            chain = .mapo
        } else if name == "polygonzkevm" {
            chain = .polygonZkEVM
        } else if name == "base" {
            chain = .base
        } else if name == "linea" {
            chain = .linea
        } else if name == "combo" {
            chain = .combo
        } else if name == "mantle" {
            chain = .mantle
        } else if name == "zkmeta" {
            chain = .zkMeta
        }
        return chain
    }

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
