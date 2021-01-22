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

class ProfileDetailsPresenter: NSObject, ProfileDetailsEvents {

var view: ProfileDetailsViewProtocol?
var router: ProfileDetailsTransitions?
var languageObservation: NSKeyValueObservation?
let currentUser = WSManager.shared.dataReceiver.user
@objc dynamic var dataReceiver: DataReceiver?
    
    init (with view: ProfileDetailsViewProtocol, router: ProfileDetailsTransitions) {
        self.view = view
        self.router = router
        self.dataReceiver = WSManager.shared.dataReceiver
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
    
    func observeLanguage() {
        languageObservation = observe(\.dataReceiver?.language, options: [.old, .new]) { object, change in
            if (change.newValue as? String) != nil {
                self.view?.localize()
            }
        }
    }
}

