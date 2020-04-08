//
//  SettingsPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/27/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class SettingsPresenter: SettingsEvents {
    var view: SettingsViewProtocol?
    var router: SettingsTransitions?
    var networkManager: NetworkAccess?
    
    init (with view: SettingsViewProtocol, networkManager: NetworkAccess, router: SettingsTransitions) {
        self.view = view
        self.networkManager = networkManager
        self.router = router
    }
    
    func profileChosen() {
        router?.goToProfile()
    }
    
    func logout() {
        networkManager?.logout(success: { successfully in
            self.router?.logout()
        }, failure: { error in
            if let error = error {
                self.view?.showErrorAlertWith(error: error)
            }
        })
    }
}
