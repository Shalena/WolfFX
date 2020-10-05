//
//  SignupViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/5/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, SignupViewProtocol, NavigationBackButtonDesign {
    
    @IBOutlet weak var firstnameTextfield: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var termsButton: CheckboxButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var presenter: SignupEvents?
    let currencies = Currency.all
    var selectedCurrency = Currency.greatBritainPound
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupBackButton()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        currencyTextField.inputView = pickerView
        currencyTextField.text = Currency.unitedStatesDollar.title
    }
    
    func setupDesign() {
        saveButton.layer.cornerRadius = 5
        saveButton.layer.cornerRadius = 5
        saveButton.layer.borderWidth = 2
        saveButton.layer.borderColor = UIColor.gray.cgColor
      }
    
    @objc func didBarButtonbBackTapped() {
        navigationController?.popViewController(animated: true)
    }
   
    @IBAction func saveButtonTapped(_ sender: Any) {
        let firstName = firstnameTextfield.text
        let email = emailTextField.text
        let password = passwordTextfield.text
        let registrationForm = RegistrationForm(firstName: firstName,
                                                    email: email,
                                                    emails: [(email ?? "")] ,
                                                    password: password,
                                                    isTerms: termsButton.isSelected,
                                                    currency: selectedCurrency.rawValue,
                                                    tenantId: "00000000-0000-0000-0000-000000000000")
        presenter?.registerUserWith(form: registrationForm, confirmPasswordString: confirmPasswordTextfield.text)
    }
}

extension SignupViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyTextField.text = currencies[row].title
        selectedCurrency = currencies[row]
    }
}


