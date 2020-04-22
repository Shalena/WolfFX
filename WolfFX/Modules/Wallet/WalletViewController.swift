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
    @IBOutlet weak var withdrawView: UIView!
    @IBOutlet weak var amountTextView: UITextField!
    @IBOutlet weak var paymentMethodTextField: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var continueButton: SubmitButton!
    var presenter: WalletEvents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        amountTextView.delegate = self
        amountTextView.addTarget(self, action: #selector(WalletViewController.textFieldDidChange(_:)),
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
        addTextToTheLeft(textfield: amountTextView)
        setupPaymentMethodTextField()
    }
   
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            presenter?.amountChanged(text: text)
        }
    }
    
    func updateWith(poundValueString: String) {
        amountLabel.text = poundValueString
    }
    
    private func addTextToTheLeft(textfield: UITextField) {
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 30.0))
        label.text = "  ¥"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.white
        label.textAlignment = .center
        textfield.leftView = label
        textfield.leftViewMode = .always
    }
    
    private func setupPaymentMethodTextField() {
        paymentMethodTextField.rightViewMode = .always
           let container = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
           let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
           imageView.image = R.image.arrowDown()
           container.addSubview(imageView)
           paymentMethodTextField.rightView = container
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
        if let text = amountTextView.text {
            presenter?.deposit(with: text)
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
