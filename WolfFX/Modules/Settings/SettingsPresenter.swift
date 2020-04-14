//
//  SettingsPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/27/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

enum LoginState {
    case userIsLoggedIn
    case userIsLoggedOut
    
    var text: String {
        switch self {
        case .userIsLoggedIn:
            return "Logout"
        case .userIsLoggedOut:
            return "Sign In"
        }
    }
}

class SettingsPresenter: NSObject, SettingsEvents {
    var view: SettingsViewProtocol?
    var router: SettingsTransitions?
    var networkManager: NetworkAccess?
    @objc dynamic var dataReceiver: DataReceiver?
    var observation: NSKeyValueObservation?
    var currentLoginState: LoginState?
    
    init (with view: SettingsViewProtocol, networkManager: NetworkAccess, router: SettingsTransitions) {
        self.view = view
        self.networkManager = networkManager
        self.router = router
        dataReceiver = DataReceiver.shared
    }
    
    func settingsViewIsReady() {
        setupLoginLogoutState()
        observe()
    }
    
    func observe() {
        observation = observe(\.dataReceiver?.user, options: [.old, .new]) { object, change in
            self.setupLoginLogoutState()
       }
    }
    
    func profileChosen() {
        if dataReceiver?.user != nil {
            router?.goToProfile()
        } else {
            router?.goToHome()
        }
    }
    
    func lastSectionTapped() {
        switch currentLoginState {
        case .userIsLoggedIn:
            logout()
        case .userIsLoggedOut:
            logout()
        case .none: return
        }
    }
    
    private func setupLoginLogoutState() {
        if DataReceiver.shared.user != nil {
            self.currentLoginState = .userIsLoggedIn
        } else {
            self.currentLoginState = .userIsLoggedOut
        }
        view?.updateloginAndSighOutLabel(with: self.currentLoginState?.text ?? "")
    }
    
    private func logout() {
        networkManager?.logout(success: { successfully in
            self.router?.logout()
        }, failure: { error in
            if let error = error {
                self.view?.showErrorAlertWith(error: error)
            }
        })
    }
}
