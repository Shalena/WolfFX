//
//  SignupViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/5/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit

let currencies = ["Euro", "United States Dollar", "British Pound"]

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
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self

        currencyTextField.delegate = self
        currencyTextField.inputView = pickerView
    }
    
    func setupDesign() {
          saveButton.layer.cornerRadius = 5
          saveButton.layer.cornerRadius = 5
          saveButton.layer.borderWidth = 2
          saveButton.layer.borderColor = UIColor.gray.cgColor
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
        return currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyTextField.text = currencies[row]
    }
}

extension SignupViewController: UITextFieldDelegate {
    
}
