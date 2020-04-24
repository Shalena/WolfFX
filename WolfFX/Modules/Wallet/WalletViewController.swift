//
//  WalletViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController, WalletViewProtocol, NavigationDesign  {
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var depositView: UIView!
    @IBOutlet weak var amountDepositTextField: UITextField!
    @IBOutlet weak var paymentMethodTextField: UITextField!
    @IBOutlet weak var exchangeDepositLabel: UILabel!
    
    @IBOutlet weak var withdrawView: UIView!
    
    @IBOutlet weak var beneficiaryNameTextField: UITextField!
    
    @IBOutlet weak var amountAvailableWithrawLabel: UILabel!
    @IBOutlet weak var beneficiaryBankAccountTextField: UITextField!
    @IBOutlet weak var withdrawalToTextField: UITextField!
    @IBOutlet weak var bankNameTextField: UITextField!
    @IBOutlet weak var amountWithdrawTextField: UITextField!
    
    @IBOutlet weak var continueButton: SubmitButton!
    @IBOutlet weak var requestWithdrawButton: SubmitButton!
    
    var presenter: WalletEvents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        amountDepositTextField.delegate = self
        amountWithdrawTextField.delegate = self
        amountDepositTextField.addTarget(self, action: #selector(WalletViewController.textFieldDidChange(_:)),
        for: .editingChanged)
        amountWithdrawTextField.addTarget(self, action: #selector(WalletViewController.textFieldDidChange(_:)),
        for: .editingChanged)
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        paymentMethodTextField.inputView = pickerView
        presenter?.walletViewIsReady()
    }
    
    func setupDesign() {
        setupBaseNavigationDesign()
        segment.defaultConfiguration()
        depositView.isHidden = false
        withdrawView.isHidden = true
        continueButton.setup(backColor: .red, borderColor: .red, text: "CONTINUE", textColor: .black)
        requestWithdrawButton.setup(backColor: .clear, borderColor: .red, text: "Request Withdrawal", textColor: .white)
        setupTextFieldsWithArrows()
        prefill(textField: amountDepositTextField, with: "¥")
        prefill(textField: amountWithdrawTextField, with: "£")
        updateAvailableAmountWithdraw()
    }
   
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {return}
        if textField == amountDepositTextField {
            presenter?.amountChanged(text: text)
        } else if textField == amountWithdrawTextField {
            
        }
    }
    
    func updateExchangeDepositLabel(with string: String) {
        exchangeDepositLabel.text = string
    }
    
    private func prefill(textField: UITextField, with text: String) {
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 30.0))
        label.text = "  " + text
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.white
        label.textAlignment = .center
        textField.leftView = label
        textField.leftViewMode = .always
    }
    
    private func setupTextFieldsWithArrows() {
        let textFields = [paymentMethodTextField, withdrawalToTextField, bankNameTextField]
        for textField in textFields {
            let container = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            imageView.image = R.image.arrowDown()
            container.addSubview(imageView)
            textField?.rightViewMode = .always
            textField?.rightView = container
        }
    }
    
    private func updateAvailableAmountWithdraw() {
        amountAvailableWithrawLabel.text = presenter?.textForAvailableAmount()
    }
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        switch segment.selectedSegmentIndex {
            case 0:
                depositView.isHidden = false
                withdrawView.isHidden = true
            case 1:
                depositView.isHidden = true
                withdrawView.isHidden = false
            default:
                break
            }
        }
    
    @IBAction func depositContinuePressed(_ sender: Any) {
        if let text = amountDepositTextField.text {
            presenter?.deposit(with: text)
        }
    }
    
    @IBAction func requestWithdrawPressed(_ sender: Any) {
        if let text = amountWithdrawTextField.text,
           let amount = Double(text),
           let bankName = bankNameTextField.text,
           let beneficiaryBankAccount = beneficiaryBankAccountTextField.text,
           let beneficiaryName = beneficiaryNameTextField.text {
           let withdrawForm = WithdrawForm(amaunt: amount, bankName: bankName, beneficiaryBankAccount: beneficiaryBankAccount, beneficiaryName: beneficiaryName)
            presenter?.withdrawRequestWith(form: withdrawForm)
        }
    }
}

extension WalletViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let letters = NSCharacterSet.letters
            if string.rangeOfCharacter(from: letters) != nil {
                return false
            } else {
                return true
        }
    }
}

extension WalletViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter?.pickerDataSource?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return presenter?.pickerDataSource?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        paymentMethodTextField.text = presenter?.pickerDataSource?[row]
   
    }
}
