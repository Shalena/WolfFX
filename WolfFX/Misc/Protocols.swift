//
//  Protocols.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/26/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

protocol ViewControllerDesign: class {
    func setupBaseNavigationDesign()
}

protocol ShowErrorCapable: class where Self: UIViewController {
    
}

extension ShowErrorCapable {
    func showErrorAlertWith(error: WolfError) {
        let errorDescription = error.errorDescription
        let alert = UIAlertController(title: nil, message: errorDescription, preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// Login Screen

protocol LoginViewProtocol: ShowErrorCapable {
    var presenter: LoginEvents? {get set}
}

protocol LoginEvents {
    func signIn(email: String, password: String)
    func signUpPressed()
}

protocol LoginTransitions {
    func userLoggedIn(user: User)
    func signUpPressed()
}

// Signup Screen

protocol SignupViewProtocol: ShowErrorCapable {
    var presenter: SignupEvents? {get set}
}

protocol SignupEvents {
     func registerUserWith(form: RegistrationForm)
}

protocol SignupTransitions {
    func userCreated(user: User)
}
// Home Screen

protocol HomeViewProtocol {
    var presenter: HomeEvents? {get set}
}

protocol HomeEvents {
    func setupLoginOverlay()
}

protocol HomeTransitions {
     func setupLoginOverlay()
}
