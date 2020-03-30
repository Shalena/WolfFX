//
//  LoginPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/2/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import ReSwift

class LoginPresenter: LoginEvents, StoreSubscriber {
    var view: LoginViewProtocol?
    var router: LoginTransitions?
    var networkManager: NetworkAccess
    var websocketManager: WebsocketAccess
    
    init (with networkManager: NetworkAccess, websocketManager: WebsocketAccess,  store: Store<AppState>, router: LoginTransitions) {
        self.networkManager = networkManager
        self.websocketManager = websocketManager
        self.router = router
        store.subscribe(self) { $0.select { $0.cState } }
    }
    
    func newState(state: CustomerState) {
           // go to home
    }
       
    func signIn(email: String, password: String) {
                networkManager.login(email: email, password: password, success: { (successfully: Bool) in
                    if successfully {
                        self.websocketManager.connect()
                        self.websocketManager.getUserInfo()
                        self.userHadSignedIn()
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
    
    func userHadSignedIn() {
        router?.removeLoginOverlay()
    }
       
    func closeScreen() {
        router?.removeLoginOverlay()
    }
}
