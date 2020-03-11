//
//  LoginViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/27/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginViewProtocol {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    var presenter: LoginEvents?
    var callback: ShowTabbarCallback?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
    }
 
     func setupDesign() {
        closeButton.layer.cornerRadius = 0.5 * closeButton.bounds.size.width
        closeButton.clipsToBounds = true
        closeButton.setImage(R.image.close(), for: .normal)
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        loginButton.layer.cornerRadius = 5
        signUpButton.layer.cornerRadius = 5
        signUpButton.layer.borderWidth = 2
        signUpButton.layer.borderColor = UIColor.red.cgColor
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if let login = emailTextfield.text, let password = passwordTextfield.text {
            presenter?.signIn(email: login, password: password)
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        if let signUpController = R.storyboard.login.signupViewController() {
            navigationController?.pushViewController(signUpController, animated: true)
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
          self.removeFromParent()
          self.view.removeFromSuperview()
          callback?()
      }
}
