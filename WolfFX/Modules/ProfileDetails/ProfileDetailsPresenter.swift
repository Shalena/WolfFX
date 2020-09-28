//
//  ProfileDetailsPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/28/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Swinject


enum UserDetailsTextFields {
    case name
    case email
    case password
    case confirmPassword
    case currency
}

class ProfileDetailsPresenter: ProfileDetailsEvents {

var view: ProfileDetailsViewProtocol?
var router: ProfileDetailsTransitions?
var websocketManager: WebsocketAccess
let currentUser = WSManager.shared.dataReceiver.user

    init (with view: ProfileDetailsViewProtocol, router: ProfileDetailsTransitions) {
        self.view = view
        self.router = router
        websocketManager = WSManager.shared
    }
    
    func textFor(textField: UserDetailsTextFields) -> String {
        switch textField {
        case .name:
            return currentUser?.firstName ?? ""
        case .email:
            return currentUser?.email ?? ""
        case .password:
            return "••••••••••••"
        case .confirmPassword:
            return "Confirm Password"
        case .currency:
            return currentUser?.currency ?? ""
        }
    }
    
    func saveDetails() {
        router?.saveDetails()
    }
}

