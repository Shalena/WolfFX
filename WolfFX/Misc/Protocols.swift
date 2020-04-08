//
//  Protocols.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/26/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

protocol JsonAcception {
    func acceptJson(json: JSON) -> Bool
}

protocol NavigationDesign: class {
    func setupBaseNavigationDesign()
}

protocol NavigationBackButtonDesign: class {
    func setupBackButton()
}

protocol HeaderDesign: class where Self: UIViewController {
    
}

extension HeaderDesign {
    func setupHeaderDesign() {
        let baseHeaderView = BaseHeaderView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.addSubview(baseHeaderView)
    }
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
    func observe()
    func signIn(email: String, password: String)
    func signUpPressed()
    func userDetailsHadReceived()
    func closeScreen()
}

protocol LoginTransitions {
    func userDetailsHadReceived()
    func signUpPressed()
    func closeScreen()
}

// Signup Screen

protocol SignupViewProtocol: ShowErrorCapable {
    var presenter: SignupEvents? {get set}
}

protocol SignupEvents {
    func observe()
    func registerUserWith(form: RegistrationForm, confirmPasswordString: String?)
    func userHadCreated()
}

protocol SignupTransitions {
    func userHadCreated()
}
// Home Screen

protocol HomeViewProtocol {
    var presenter: HomeEvents? {get set}
}

protocol HomeEvents {
    func setupLoginOverlay()
    func homeViewIsReady()
}

protocol HomeTransitions {
     func setupLoginOverlay()
}

// Settings Screen

protocol SettingsViewProtocol: ShowErrorCapable {
    var presenter: SettingsEvents? {get set}
}

protocol SettingsEvents {
    func profileChosen()
    func logout()
}

protocol SettingsTransitions {
    func goToProfile()
    func logout()
}

// Profile details Screen

protocol ProfileDetailsViewProtocol {
    var presenter: ProfileDetailsEvents? {get set}
}

protocol ProfileDetailsEvents {
    func textFor(textField: UserDetailsTextFields) -> String 
    func saveDetails()
}

protocol ProfileDetailsTransitions {
     func saveDetails()
}
