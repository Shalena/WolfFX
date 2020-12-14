//
//  ResetPasswordController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 12/7/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class ResetPasswordController: UIViewController, ResetPasswordViewProtocol, NavigationBackButtonDesign {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textFieldTitle: UILabel!
    @IBOutlet weak var sendButton: SubmitButton!
    @IBOutlet weak var textField: UITextField!
    var presenter: ResetPasswordEvents?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        localize()
    }
    
    private func localize() {
        titleLabel.text = R.string.localizable.restorePassword()
        textFieldTitle.text = R.string.localizable.yourEmail()
        textField.attributedPlaceholder = NSAttributedString(string: R.string.localizable.email(),
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        sendButton.setup(backColor: .clear, borderColor: .red, text: R.string.localizable.send(), textColor: .white)
    }
    
    @objc func didBarButtonbBackTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        if let email = textField.text {
             presenter?.resetPasswordWith(email: email)
        }
    }
}
