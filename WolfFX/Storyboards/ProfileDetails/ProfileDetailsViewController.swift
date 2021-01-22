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
    @IBOutlet weak var profileTitle: UILabel!
    @IBOutlet weak var firstNameTitle: UILabel!
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var currencyTitle: UILabel!
    @IBOutlet weak var clickHereToAccept: UILabel!
    
    var presenter: ProfileDetailsEvents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseNavigationDesign()
        setupBackButton()
        saveButton.setup(backColor: .clear, borderColor: .gray, text: R.string.localizable.save(), textColor: .gray)
        configureTextFields()
        localize()
    }

    func localize() {
        profileTitle.text = R.string.localizable.profile().localized()
        firstNameTitle.text = NSLocalizedString("First name", comment: "")
        emailTitle.text = R.string.localizable.email().localized()
        passwordTitle.text = R.string.localizable.password().localized()
        currencyTitle.text = R.string.localizable.currency().localized()
        clickHereToAccept.text = R.string.localizable.clickHereToAcceptOurClientAgreement().localized()
    }
     
   private func configureTextFields() {
        firstNameTextField.text = presenter?.textFor(textField: UserDetailsTextFields.name)
        emailTextField.text = presenter?.textFor(textField: UserDetailsTextFields.email)
        passwordTextField.text = presenter?.textFor(textField: UserDetailsTextFields.password)       
        confirmPasswordTextfield.placeholder = presenter?.textFor(textField: UserDetailsTextFields.confirmPassword)
        passwordTextField.autocorrectionType = .no
        confirmPasswordTextfield.autocorrectionType = .no
        currencyTextfield.text = presenter?.textFor(textField: UserDetailsTextFields.currency)
    }
}
