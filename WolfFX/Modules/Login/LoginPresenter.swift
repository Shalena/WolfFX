//
//  LoginPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/2/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class LoginPresenter: LoginEvents {
    var view: LoginViewProtocol?
    var router: LoginTransitions?
    var networkManager: NetworkAccess
    var websocketManager: WebsocketAccess
    
    init (with networkManager: NetworkAccess, websocketManager: WebsocketAccess) {
        self.networkManager = networkManager
        self.websocketManager = websocketManager
    }
    
    func signIn(email: String, password: String) {
                networkManager.login(email: email, password: password, success: { (successfully: Bool) in
                    if successfully {
                        self.websocketManager.connect()
                        self.websocketManager.getUserInfo()
                    }
                }, failure: { [weak self] error in
                    if let error = error {
                      self?.view?.showErrorAlertWith(error: error)
                    }
                })
    }
    
    func signUpPressed () {
        router?.signUpPressed ()
    }
}
