//
//  SignupViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/5/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, SignupViewProtocol {
    
    @IBOutlet weak var firstnameTextfield: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var currencyTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    var presenter: SignupEvents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
    }
    
    func setupDesign() {
          saveButton.layer.cornerRadius = 5
          saveButton.layer.cornerRadius = 5
          saveButton.layer.borderWidth = 2
          saveButton.layer.borderColor = UIColor.gray.cgColor
      }
      
}
 
