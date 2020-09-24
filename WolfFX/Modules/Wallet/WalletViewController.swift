//
//  WalletViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit
import WebKit

class WalletViewController: UIViewController, WalletViewProtocol, NavigationDesign  {
    @IBOutlet weak var myWalletTitle: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var depositView: UIView!
    @IBOutlet weak var depositTitle: UILabel!
    @IBOutlet weak var pleaseConfirmYourMethodTitle: UILabel!
    @IBOutlet weak var enterAmountTitle: UILabel!
    @IBOutlet weak var amountDepositTextField: UITextField!
    @IBOutlet weak var paymentMethodTextField: UITextField!
    @IBOutlet weak var exchangeDepositLabel: UILabel!
    @IBOutlet weak var withdrawView: UIView!
    @IBOutlet weak var requestForMoneyWithdrawal: UILabel!
    @IBOutlet weak var withdrawalTo: UILabel!
    @IBOutlet weak var amountAvailable: UILabel!
    @IBOutlet weak var bankNameTitle: UILabel!
    @IBOutlet weak var beneficiaryBankAccount: UILabel!
    @IBOutlet weak var beneficiaryName: UILabel!
    @IBOutlet weak var beneficiaryNameTextField: UITextField!
    @IBOutlet weak var amountAvailableWithrawLabel: UILabel!
    @IBOutlet weak var rmbLabel: UILabel!
    @IBOutlet weak var beneficiaryBankAccountTextField: UITextField!
    @IBOutlet weak var withdrawalToTextField: UITextField!
    @IBOutlet weak var bankNameTextField: UITextField!
    @IBOutlet weak var amountWithdrawTextField: UITextField!
    @IBOutlet weak var continueButton: SubmitButton!
    @IBOutlet weak var requestWithdrawButton: SubmitButton!
    
    var paymentMethodPickerView: UIPickerView?
    var bankPickerView: UIPickerView?
    var webView: WKWebView!
    
    var presenter: WalletEvents?
    
    func loadWebView(string: String) {
        webView = WKWebView(frame: view.frame)
        webView.navigationDelegate = self
        view.addSubview(webView)
        showHud()
        webView.loadHTMLString(string, baseURL: nil)
        webView.allowsBackForwardNavigationGestures = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        localize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        amountDepositTextField.delegate = self
        amountWithdrawTextField.delegate = self
        amountDepositTextField.addTarget(self, action: #selector(WalletViewController.textFieldDidChange(_:)),
        for: .editingChanged)
        amountWithdrawTextField.addTarget(self, action: #selector(WalletViewController.textFieldDidChange(_:)),
        for: .editingChanged)
        paymentMethodPickerView = UIPickerView()
        paymentMethodPickerView?.delegate = self
        paymentMethodPickerView?.dataSource = self
        paymentMethodTextField.inputView = paymentMethodPickerView
        bankPickerView = UIPickerView()
        bankPickerView?.delegate = self
        bankPickerView?.dataSource = self
        bankNameTextField.inputView = bankPickerView
        presenter?.walletViewIsReady()
        localize()
    }
    
    func setupDesign() {
        setupBaseNavigationDesign()
        segment.defaultConfiguration()
        depositView.isHidden = false
        withdrawView.isHidden = true
        continueButton.setup(backColor: .red, borderColor: .red, text: R.string.localizable.continue().localized(), textColor: .black)
        requestWithdrawButton.setup(backColor: .clear, borderColor: .red, text: R.string.localizable.requestWithdrawal().localized(), textColor: .white)
        setupTextFieldsWithArrows()
        prefill(textField: amountDepositTextField, with: "¥")
        prefill(textField: amountWithdrawTextField, with: "£")
    }
    
    func localize() {
        
        myWalletTitle.text = R.string.localizable.myWallet().localized()
        segment.setTitle(R.string.localizable.deposit().localized().uppercased(), forSegmentAt: 0)
        segment.setTitle(R.string.localizable.withdraw().localized().uppercased(), forSegmentAt: 1)
         //Deposit
        depositTitle.text = R.string.localizable.deposit().localized()
        enterAmountTitle.text = R.string.localizable.enterAmount().localized()
        pleaseConfirmYourMethodTitle.text = R.string.localizable.pleaseConfirmYourPaymentMethodFromTheListBelow().localized()
         // Withdraw
        requestForMoneyWithdrawal.text = R.string.localizable.requestForMoneyWithdrawal().localized()
        presenter?.forceLocalizeUpdatePicker() // localize strings in the picker
        paymentMethodTextField.text = presenter?.pickerDataSource?[0].localized()
        withdrawalTo.text = R.string.localizable.withdrawalTo().localized()
        withdrawalToTextField.text = presenter?.pickerDataSource?[0].localized()
        rmbLabel.text = R.string.localizable.rmbToBePaid().localized()
        bankNameTitle.text = R.string.localizable.bankName().localized()
        beneficiaryBankAccount.text = R.string.localizable.beneficiaryBankAccount().localized()
        beneficiaryName.text = R.string.localizable.beneficiaryName().localized()
        updateAvailableAmountWithdraw() // string is calculated
        continueButton.setTitle(R.string.localizable.continue().localized().uppercased(), for: .normal) // tricky sutiation, we have 2 places where title for button is set up
        requestWithdrawButton.setTitle(R.string.localizable.requestWithdrawal().localized(), for: .normal)
     }
   
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {return}
        if textField == amountDepositTextField {
            presenter?.amountDepositChanged(text: text)
        } else if textField == amountWithdrawTextField {
            presenter?.amountWithdrawChanged(text: text)
        }
    }
    
    func updateExchangeDepositLabel(with string: String) {
        exchangeDepositLabel.text = string
    }
    
    func updateRMBLabel(with string: String) {
        rmbLabel.text = string
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
        if pickerView == paymentMethodPickerView {
            return presenter?.pickerDataSource?.count ?? 0
        } else if pickerView == bankPickerView {
            return presenter?.pickerBankDataSource?.count ?? 0
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == paymentMethodPickerView {
            return presenter?.pickerDataSource?[row]
        } else if pickerView == bankPickerView {
            return presenter?.pickerBankDataSource?[row].title
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == paymentMethodPickerView {
            paymentMethodTextField.text = presenter?.pickerDataSource?[row]
        } else if pickerView == bankPickerView {
            bankNameTextField.text = presenter?.pickerBankDataSource?[row].title
        }
        view.endEditing(true)
    }
}

  extension WalletViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideHud()
        let substring = BaseUrl.stage.rawValue
        if let url = webView.url?.absoluteString, url.contains(substring) {
            webView.removeFromSuperview()
        }
    }
}
