//
//  SignupViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/5/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit

let defaultTenantId = "00000000-0000-0000-0000-000000000000"

class SignupViewController: UIViewController, SignupViewProtocol, NavigationBackButtonDesign, UITextFieldDelegate, KeyboardHandler {
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstNameTitle: UILabel!
    @IBOutlet weak var firstnameTextfield: UITextField!
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var currencyTItle: UILabel!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var termsButton: CheckboxButton!
    @IBOutlet weak var termsTextView: UITextView!
    @IBOutlet weak var saveButton: SubmitButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var presenter: SignupEvents?
    let currencies = Currency.all
    var selectedCurrency = Currency.greatBritainPound
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        setupBackButton()
        saveButton.setupInactiveState()
        termsButton.callback = {
            self.checkFormAndUpdateSaveButton()
        }
       
        termsTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        termsTextView.centerVerticalText()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        currencyTextField.inputView = pickerView
        currencyTextField.text = Currency.unitedStatesDollar.title
        firstnameTextfield.delegate = self
        firstnameTextfield.addTarget(self, action: #selector(SignupViewController.textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(SignupViewController.textFieldDidChange(_:)), for: .editingChanged)
        currencyTextField.delegate = self
        currencyTextField.addTarget(self, action: #selector(SignupViewController.textFieldDidChange(_:)), for: .editingChanged)
        passwordTextfield.delegate = self
        passwordTextfield.addTarget(self, action: #selector(SignupViewController.textFieldDidChange(_:)), for: .editingChanged)
        confirmPasswordTextfield.delegate = self
        confirmPasswordTextfield.addTarget(self, action: #selector(SignupViewController.textFieldDidChange(_:)), for: .editingChanged)
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
        titleLabel.text = R.string.localizable.createYourAccount()
        firstNameTitle.text = R.string.localizable.firstName()
        emailTitle.text = R.string.localizable.email()
        passwordTitle.text = R.string.localizable.password()
        passwordTextfield.placeholder = R.string.localizable.enterYourPassword()
        confirmPasswordTextfield.placeholder = R.string.localizable.confirmPassword()
        currencyTItle.text = R.string.localizable.currency()
        addUrl()
    }
    
    func addUrl() {
        let attributedString = NSMutableAttributedString(string: R.string.localizable.clickHereToAcceptOurClientAgreement())
        attributedString.addAttribute(.link, value: clientAgreementUrlString, range: NSRange(location: 0, length: attributedString.length))
        termsTextView.attributedText = attributedString
    }
    
    @objc func didBarButtonbBackTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkFormAndUpdateSaveButton()
    }
   
    private func checkFormAndUpdateSaveButton() {
        if let firstName = firstnameTextfield.text, firstName.count > 0,
           let email = emailTextField.text, email.count > 0,
           let password = passwordTextfield.text, password.count > 0,
           let confirmPassword = confirmPasswordTextfield.text, confirmPassword.count > 0 && termsButton.isSelected {
            saveButton.setupActiveState()
        } else {
            saveButton.setupInactiveState()
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let firstName = firstnameTextfield.text,
            let email = emailTextField.text,
            let password = passwordTextfield.text,
            let confirmPassword = confirmPasswordTextfield.text {
            let registrationForm = RegistrationForm(firstName: firstName,
                                                    email: email,
                                                    emails: [email] ,
                                                    password: password,
                                                    isTerms: termsButton.isSelected,
                                                    currency: selectedCurrency.rawValue,
                                                    tenantId: defaultTenantId)
            presenter?.registerUserWith(form: registrationForm, confirmPasswordString: confirmPassword)
        }
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

extension SignupViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
           UIApplication.shared.open(URL)
           return false
       }
}
