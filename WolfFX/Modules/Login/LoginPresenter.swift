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
    var webSocketTask: URLSessionWebSocketTask?
    
    init (with networkManager: NetworkAccess) {
        self.networkManager = networkManager
    }
    
    func signIn(email: String, password: String) {
        //        networkManager.login(email: email, password: password, success: { (successfully: Bool) in
        //            if successfully {
        //                 // start websocket
        //            }
        //        }, failure: { [weak self] error in
        //            if let error = error {
        //              self?.view?.showErrorAlertWith(error: error)
        //            }
        //        })
       WSManager.shared.connectToWebSocket() // подключаемся
       WSManager.shared.subscribeBtcUsd() //подписываемся на получение данных
       self.getData() //

    }
    private func getData() {
         //получаем данные
         WSManager.shared.receiveData() { [weak self] (data) in
             guard let self = self else { return }
             guard let data = data else { return }
            
         }
     }
    
    func signUpPressed () {
        router?.signUpPressed ()
    }
}
