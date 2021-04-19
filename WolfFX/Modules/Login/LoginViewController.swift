//
//  LoginViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/27/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, NavigationDesign, LoginViewProtocol, KeyboardHandler {
    
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: SubmitButton!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var restorePasswordButton: UIButton!
    
    var presenter: LoginEvents?
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseNavigationDesign()
        signUpButton.setup(backColor: .clear, borderColor: .darkGray, text: R.string.localizable.signUp().localized(), textColor: .white)
        localize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startObservingKeyboardChanges()
    }
    
    func registerForKeyboardEvents() {
           NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
       }
    @objc func keyboard(notification:Notification) {
        guard let keyboardReact = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification ||  notification.name == UIResponder.keyboardWillChangeFrameNotification {
            bottomConstraint.constant = keyboardReact.height
        } else {
            bottomConstraint.constant = 0
        }
    }
    
    func localize() {
        loginLabel.text = R.string.localizable.logIn().localized()
        emailLabel.text = R.string.localizable.emailOnLogin().localized()
        passwordLabel.text = R.string.localizable.passwordOnLogin().localized()
        loginButton.setTitle(R.string.localizable.logIn().localized(), for: .normal)
        restorePasswordButton.setTitle(R.string.localizable.restorePassword(), for: .normal)
        orLabel.text = R.string.localizable.or().localized()
        signUpButton.setTitle(R.string.localizable.signUp().localized(), for: .normal)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if let login = emailTextfield.text, let password = passwordTextfield.text {
            presenter?.signIn(email: login, password: password)
        }
    }
    
    @IBAction func restorePasswordAction(_ sender: Any) {
        presenter?.resetPasswordPressed()
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        presenter?.signUpPressed()
    }
    
    @IBAction func close(_ sender: UIButton) {
        presenter?.closeScreen()
    }
}
