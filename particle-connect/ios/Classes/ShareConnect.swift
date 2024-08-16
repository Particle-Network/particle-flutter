//
//  ShareConnect.swift
//  particle_connect
//
//  Created by link on 15/08/2024.
//

import AuthCoreAdapter
import Base58_swift
import ConnectCommon
import Foundation
import ParticleAuthCore
import ParticleNetworkBase
import ParticleNetworkChains
import RxSwift
import SwiftyJSON

typealias ShareCallback = (Any) -> Void

class ShareConnect {
    static let shared: ShareConnect = .init()
    
    let bag = DisposeBag()
    
    
}
