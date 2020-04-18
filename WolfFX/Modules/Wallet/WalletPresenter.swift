//
//  WalletPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/18/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class WalletPresenter: WalletEvents {
var view: WalletViewProtocol?
var router: WalletTransitions?
var networkManager: NetworkAccess?


init (with view: WalletViewProtocol, networkManager: NetworkAccess, router: WalletTransitions) {
    self.view = view
    self.networkManager = networkManager
    self.router = router
}

func walletViewIsReady() {
  
}
}
