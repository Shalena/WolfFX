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
    @IBOutlet weak var restorePasswordButton: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: SubmitButton!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    var presenter: LoginEvents?
      
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        presenter?.observe()
        localize()
    }
    
     func setupDesign() {
        closeButton.layer.cornerRadius = 0.5 * closeButton.bounds.size.width
        closeButton.clipsToBounds = true
        closeButton.setImage(R.image.close(), for: .normal)
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        signUpButton.setup(backColor: .clear, borderColor: .darkGray, text: "Sign up", textColor: .white)
    }
    
    func localize() {
        loginLabel.text = R.string.localizable.logIn()
        emailLabel.text = R.string.localizable.email()
        passwordLabel.text = R.string.localizable.password()
        loginButton.setTitle(R.string.localizable.logIn(), for: .normal)
        restorePasswordButton.setTitle(R.string.localizable.restorePassword(), for: .normal)
        orLabel.text = R.string.localizable.or()
        signUpButton.setTitle(R.string.localizable.signUp(), for: .normal)
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
