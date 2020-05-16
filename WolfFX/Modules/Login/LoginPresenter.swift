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
    var websocketManager: WebsocketAccess?
    @objc dynamic var dataReceiver: DataReceiver?
    var observation: NSKeyValueObservation?
    
    init (with view: LoginViewProtocol, networkManager: NetworkAccess, router: LoginTransitions) {
        self.view = view
        self.networkManager = networkManager
        self.websocketManager = WSManager.shared
        self.router = router
        dataReceiver = DataReceiver.shared
    }

    func observe() {
        observation = observe(\.dataReceiver?.user, options: [.old, .new]) { object, change in
            self.userDetailsHadReceived()
        }
    }
    
    func signIn(email: String, password: String) {
        view?.showHud()
        networkManager?.login(email: email, password: password, success: { (successfully: Bool) in
                    if successfully {
                        self.websocketManager?.connect()
                        self.websocketManager?.getUserInfo()
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
    
    func userDetailsHadReceived() {
        router?.userDetailsHadReceived()
    }
       
    func closeScreen() {
        router?.closeScreen()
    }
}
