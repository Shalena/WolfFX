//
//  LoginViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/27/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginViewProtocol {
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: SubmitButton!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    var presenter: LoginEvents?
      
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.setup(backColor: .clear, borderColor: .darkGray, text: R.string.localizable.signUp().localized(), textColor: .white)
        localize()
    }
    
    func localize() {
        loginLabel.text = R.string.localizable.logIn().localized()
        emailLabel.text = R.string.localizable.emailOnLogin().localized()
        passwordLabel.text = R.string.localizable.passwordOnLogin().localized()
        loginButton.setTitle(R.string.localizable.logIn().localized(), for: .normal)
        orLabel.text = R.string.localizable.or().localized()
        signUpButton.setTitle(R.string.localizable.signUp().localized(), for: .normal)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if let login = emailTextfield.text, let password = passwordTextfield.text {
            presenter?.signIn(email: login, password: password)
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        presenter?.signUpPressed()
    }
    
    @IBAction func close(_ sender: UIButton) {
        presenter?.closeScreen()
    }
}
