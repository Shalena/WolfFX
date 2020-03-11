//
//  SignupPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/11/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class SignupPresenter: SignupEvents {
    var view: SignupViewProtocol?
    var router: SignupTransitions?
    var networkManager: NetworkAccess
    
    init (with networkManager: NetworkAccess) {
        self.networkManager = networkManager
    }
    
    func signup(firstname: String, currency: String, emails: [String], password: String, tenantId: String, username: String) {
        networkManager.signup(firstname: firstname, currency: currency, emails: emails, password: password, tenantId: tenantId, username: username, success: { (successfully: Bool) in
                    if successfully {
                        // start websocket
                    }
                }, failure: { [weak self] error in
                    if let error = error {
                      self?.view?.showErrorAlertWith(error: error)
                    }
                })
    }
}
