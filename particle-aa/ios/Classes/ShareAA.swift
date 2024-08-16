//
//  ShareAA.swift
//  particle_aa
//
//  Created by link on 16/08/2024.
//

import Foundation
import ParticleAA
import ParticleNetworkBase
import RxSwift
import SwiftyJSON

typealias ShareCallback = (Any) -> Void

class ShareAA {
    static let shared: ShareAA = .init()
    
    let bag = DisposeBag()
    
    func initialize(_ json: String) {
        let data = JSON(parseJSON: json)
        
        let name = data["name"].stringValue.uppercased()
        let version = data["version"].stringValue.lowercased()
        
        let accountName = AA.AccountName(version: version, name: name)
        let all: [AA.AccountName] = AA.AccountName.allCases
        if all.contains(accountName) {
            AAService.initialize(name: accountName)
        } else {
            print("config aa error, wrong version and name")
        }
    }
    
    func isDeploy(_ json: String, callback: @escaping ShareCallback) {
        let eoaAddress = json
        let chainInfo = ParticleNetwork.getChainInfo()
        guard let aaService = ParticleNetwork.getAAService() else {
            let response = PNResponseError(code: nil, message: "aa service is not init", data: nil)
            let statusModel = PNStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            callback(json)
            return
        }
        subscribeAndCallback(observable: aaService.isDeploy(eoaAddress: eoaAddress, chainInfo: chainInfo), callback: callback)
    }
    
    func isAAModeEnable() -> Bool {
        return ParticleNetwork.getAAService()?.isAAModeEnable() ?? false
    }
    
    func enableAAMode() {
        ParticleNetwork.getAAService()?.enableAAMode()
    }
    
    func disableAAMode() {
        ParticleNetwork.getAAService()?.disableAAMode()
    }
    
    func rpcGetFeeQuotes(_ json: String, callback: @escaping ShareCallback) {
        let data = JSON(parseJSON: json)
        let eoaAddress = data["eoa_address"].stringValue
        let transactions = data["transactions"].arrayValue.map {
            $0.stringValue
        }
        let chainInfo = ParticleNetwork.getChainInfo()
        guard let aaService = ParticleNetwork.getAAService() else {
            let response = PNResponseError(code: nil, message: "aa service is not init", data: nil)
            let statusModel = PNStatusModel(status: false, data: response)
            let data = try! JSONEncoder().encode(statusModel)
            guard let json = String(data: data, encoding: .utf8) else { return }
            callback(json)
            return
        }
        
        subscribeAndCallback(observable: aaService.rpcGetFeeQuotes(eoaAddress: eoaAddress, transactions: transactions, chainInfo: chainInfo), callback: callback)
    }
}

extension ShareAA {
    private func subscribeAndCallback<T: Codable>(observable: Single<T>, callback: @escaping ShareCallback) {
        observable.subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let response = responseFromError(error)
                let statusModel = PNStatusModel(status: false, data: response)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback(json)
            case .success(let signedMessage):
                let statusModel = PNStatusModel(status: true, data: signedMessage)
                let data = try! JSONEncoder().encode(statusModel)
                guard let json = String(data: data, encoding: .utf8) else { return }
                callback(json)
            }
        }.disposed(by: bag)
    }
}
