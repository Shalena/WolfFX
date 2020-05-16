//
//  Protocols.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/26/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit
import KRProgressHUD

protocol JsonAcception {
    func acceptJson(json: JSON) -> Bool
}

protocol NavigationDesign: class {
    func setupBaseNavigationDesign()
}

protocol NavigationBackButtonDesign: class {
    func setupBackButton()
}

protocol HeaderDesign: class where Self: UIViewController {
    
}

extension HeaderDesign {
    func setupHeaderDesign() {
        let baseHeaderView = BaseHeaderView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.addSubview(baseHeaderView)
    }
}

protocol ShowErrorCapable: class where Self: UIViewController {
    
}

extension ShowErrorCapable {
    func showErrorAlertWith(error: WolfError) {
        let errorDescription = error.errorDescription
        let alert = UIAlertController(title: nil, message: errorDescription, preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

protocol ShowHudCapable: class where Self: UIViewController {
    
}

extension ShowHudCapable {
   func showHud() {
        KRProgressHUD.show()
   }
   
   func hideHud() {
        KRProgressHUD.dismiss()
   }
}

protocol ShowAlertCapable: class where Self: UIViewController {
    
}

extension ShowAlertCapable {
    func showAlertWith(text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// Login Screen

protocol LoginViewProtocol: ShowErrorCapable, ShowHudCapable {
    var presenter: LoginEvents? {get set}
}

protocol LoginEvents {
    func observe()
    func signIn(email: String, password: String)
    func signUpPressed()
    func userDetailsHadReceived()
    func closeScreen()
}

protocol LoginTransitions {
    func userDetailsHadReceived()
    func signUpPressed()
    func closeScreen()
}

// Signup Screen

protocol SignupViewProtocol: ShowErrorCapable {
    var presenter: SignupEvents? {get set}
}

protocol SignupEvents {
    func observe()
    func registerUserWith(form: RegistrationForm, confirmPasswordString: String?)
    func userHadCreated()
}

protocol SignupTransitions {
    func userHadCreated()
}

// Home Screen

protocol HomeViewProtocol: ShowHudCapable {
    var presenter: HomeEvents? {get set}
    func updateAssetsTable()
    func redrawChart()
    func updateChart(with entries: [PriceEntry])
    func updateChartWithNewValue(assetPrice: AssetPrice)
}

protocol HomeEvents {
    var investmentDataSource: [PickerEntry] {get}
    var leverageDataSource: [PickerEntry] {get}
    var expiryDataSource: [PickerEntry] {get}
    var selectedInvestment: PickerEntry? {get set}
    var selectedLeverage: PickerEntry? {get set}
    var selectedExpiry: PickerEntry? {get set}
    var selectedAsset: Asset? {get set}
    var tableDataSource: AssetsDataSource? {get set}
    func setupLoginOverlay()
    func homeViewIsReady()
    func textForInfoLabel() -> String?
    func update(cell: AssetCell, with text: String)
    func tradeAction()
}

protocol HomeTransitions {
     func setupLoginOverlay()
}

// Billing Data Screen

protocol BillingDataViewProtocol {
    var presenter: BillingDataEvents? {get set}
    func updateViewWith(data: BillingData)
}

protocol BillingDataEvents {
    func billingDataViewIsReady()
    func showRange()
}

protocol BillingDataTransitions {
     
}

// Wallet Screen

protocol WalletViewProtocol: ShowErrorCapable, ShowAlertCapable {
    var presenter: WalletEvents? {get set}
    func updateExchangeDepositLabel(with string: String)
    func updateRMBLabel(with string: String)
}

protocol WalletEvents {
    var pickerDataSource: [String]? { get set }
    func walletViewIsReady()
    func getExchangeRate()
    func textForAvailableAmount() -> String
    func amountDepositChanged(text: String)
    func amountWithdrawChanged(text: String)
    func deposit(with amount: String)
    func withdrawRequestWith(form: WithdrawForm)
}

protocol WalletTransitions {
     
}

// Settings Screen

protocol SettingsViewProtocol: ShowErrorCapable {
    var presenter: SettingsEvents? {get set}
    func updateloginAndSighOutLabel(with text: String)
}

protocol SettingsEvents {
    func settingsViewIsReady()
    func profileChosen()
    func lastSectionTapped()
}

protocol SettingsTransitions {
    func goToProfile()
    func goToHome()
    func logout()
}

// Profile details Screen

protocol ProfileDetailsViewProtocol {
    var presenter: ProfileDetailsEvents? {get set}
}

protocol ProfileDetailsEvents {
    func textFor(textField: UserDetailsTextFields) -> String 
    func saveDetails()
}

protocol ProfileDetailsTransitions {
     func saveDetails()
}
