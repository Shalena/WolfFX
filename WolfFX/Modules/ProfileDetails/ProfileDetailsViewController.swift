//
//  ProfileDetailsViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/27/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class ProfileDetailsViewController: UIViewController, ProfileDetailsViewProtocol, NavigationDesign, NavigationBackButtonDesign {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var currencyTextfield: UITextField!
    @IBOutlet weak var saveButton: SubmitButton!

    var presenter: ProfileDetailsEvents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseNavigationDesign()
        setupBackButton()
        saveButton.setup(backColor: .clear, borderColor: .gray, text: "Save", textColor: .gray)
        configureTextFields()
    }
    
   private func configureTextFields() {
        firstNameTextField.text = presenter?.textFor(textField: UserDetailsTextFields.name)
        emailTextField.text = presenter?.textFor(textField: UserDetailsTextFields.email)
        passwordTextField.text = presenter?.textFor(textField: UserDetailsTextFields.password)
        confirmPasswordTextfield.placeholder = presenter?.textFor(textField: UserDetailsTextFields.confirmPassword)
        currencyTextfield.text = presenter?.textFor(textField: UserDetailsTextFields.currency)
    }
}
