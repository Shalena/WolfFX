//
//  HomePresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/7/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class HomePresenter: NSObject, HomeEvents {
    var view: HomeViewProtocol?
    var router: HomeTransitions?
    var networkManager: NetworkAccess
    @objc dynamic var dataReceiver: DataReceiver?
    var observation: NSKeyValueObservation?
    var assets: [Asset]?
    var websocketManager: WebsocketAccess?
    var timer: Timer?
    
    init (with networkManager: NetworkAccess) {
        self.networkManager = networkManager
        self.dataReceiver = DataReceiver.shared
        self.websocketManager = WSManager.shared
    }
    
    func setupLoginOverlay() {
        router?.setupLoginOverlay()
    }
    
    func homeViewIsReady() {
        observe()
        websocketManager?.getBalance()        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.websocketManager?.getAssetPrice()
        }
    }
    
   func observe() {
    observation = observe(\.dataReceiver?.assets, options: [.old, .new]) { object, change in
        if let assets = change.newValue {
            self.assets = assets
        }
        }
    }
}
    
