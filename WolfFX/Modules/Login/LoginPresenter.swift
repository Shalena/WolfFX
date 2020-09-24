//
//  LoginPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/2/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class LoginPresenter: NSObject, LoginEvents {
    var view: LoginViewProtocol?
    var router: LoginTransitions?
    var networkManager: NetworkAccess?
    
    init (with view: LoginViewProtocol, networkManager: NetworkAccess, router: LoginTransitions) {
        self.view = view
        self.networkManager = networkManager
        self.router = router
    }

    func signIn(email: String, password: String) {
        view?.showHud()
        networkManager?.login(email: email, password: password, success: { (successfully: Bool) in
                    if successfully {
                        self.router?.loginFirstStepFinishedSuccessfully(with: email, password: password)
                    }
                }, failure: { [weak self] error in
                    self?.view?.hideHud()
                    if let error = error {
                      self?.view?.showErrorAlertWith(error: error)
                    }
                })
    }
    
    func signUpPressed () {
        router?.signUpPressed ()
    }
    
    func closeScreen() {
        router?.closeScreen()
    }
}
