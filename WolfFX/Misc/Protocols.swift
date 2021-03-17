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
import Charts

protocol JsonAcception {
    func acceptJson(json: JSON) -> Bool
}

protocol NavigationDesign: class {
    func setupBaseNavigationDesign()
}

protocol NavigationBackButtonDesign: class {
    func setupBackButton()
}

protocol LocalizableScreen: class {
    func localize()
}

protocol LanguageObserver: class {
    var languageObservation: NSKeyValueObservation? {get set}
    func observeLanguage()
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
    KRProgressHUD.set(activityIndicatorViewColors: [UIColor.red])
    KRProgressHUD.set(style: KRProgressHUDStyle.custom(background: UIColor.clear, text: UIColor.clear, icon: UIColor.clear))
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

protocol LoginViewProtocol: ShowErrorCapable, ShowHudCapable, LocalizableScreen {
    var presenter: LoginEvents? {get set}
}

protocol LoginEvents {
    func signIn(email: String, password: String)
    func signUpPressed()
    func resetPasswordPressed()
    func closeScreen()
}

protocol LoginTransitions {
    func loginFirstStepFinishedSuccessfully(with email: String, password: String)
    func signUpPressed()
    func gotoResetPassword()
    func closeScreen()
}

// Reset Password Screen

protocol ResetPasswordViewProtocol: ShowErrorCapable, ShowHudCapable, ShowAlertCapable {
    
}

protocol ResetPasswordEvents {
    func resetPasswordWith(email: String)
}

protocol ResetPasswordTransitions {
    func resetWasSentSuccessfully()
}

// Signup Screen

protocol SignupViewProtocol: LocalizableScreen, ShowErrorCapable, ShowHudCapable {
    var presenter: SignupEvents? {get set}
}

protocol SignupEvents {
    func registerUserWith(form: RegistrationForm, confirmPasswordString: String?)
}

protocol SignupTransitions {
  func registrationFinishedSuccessfully()
}

// Home Screen

protocol HomeViewProtocol: ShowHudCapable, LocalizableScreen, ShowAlertCapable, ShowErrorCapable {
    var presenter: HomeEvents? {get set}
    var shapshots: [Snapshot] {get set}
    func setupPlayButtonDesign()
    func updateAssetsTable()
    func reloadInvestmentPicker()
    func updatePickersTextFields()
    func updateAssetButton(with title: String)
    func updateChart(with entries: [PriceEntry])
    func updateChartWithNewValue(assetPrice: AssetPrice)
    func updateMinValue(with string: String)
    func updateMaxValue(with string: String)
    func initialXvalue() -> Double?
    func update(snapshots: [Snapshot])
    func updateSnapshots(with snapshot: Snapshot)
    func makeShift()
    func showHowToTradeAlert()
}

protocol HomeEvents: LanguageObserver {
    var userCanPlay: Bool {get set}
    var shouldPerformHTTPLogin: Bool {get set}
    var shouldShowHowToTrade: Bool {get set}
    var investmentDataSource: [PickerEntry] {get}
    var leverageDataSource: [PickerEntry] {get}
    var selectedInvestment: PickerEntry? {get set}
    var selectedLeverage: PickerEntry? {get set}
    var selectedExpiry: PickerEntry? {get set}
    var selectedAsset: Asset? {get set}
    var tableDataSource: AssetsDataSource? {get set}
    var expiryDataSource: [PickerEntry]? {get set}
    func homeViewIsReady()
    func textForInfoLabel() -> String?
    func update(cell: AssetCell, with text: String)
    func tradeAction()
    func maxForSnapshot() -> Double?
    func minForSnapshot() -> Double?
}

protocol HomeTransitions {
    func userHadSuccessfullyLoggedIn()
    func goToDeposit()
    func loginFailed()
    func appHadFirstLaunch()
}

// Billing Data Screen

protocol BillingDataViewProtocol: LocalizableScreen, ShowHudCapable {
    var presenter: BillingDataEvents? {get set}
    func updateViewWith(viewModel: AccountDataViewModel)
    func hideHistoryIfNecessary(necessary: Bool)
    func reloadBalanceHistory(scrollIndex: Int, completion:@escaping TableReloadedCompletion, scrolling: Bool)
    func showFooterButton()
    func hideFooterButton()
    func updateFooterButton(title: String)
}

protocol BillingDataEvents {
    var globalDataSource: [[[(Date, BalanceHistoryItemViewModel)]]] {get set}
    var currentDataSource: [[(Date, BalanceHistoryItemViewModel)]] {get set}
    func billingDataViewIsReady()
    func showNextRangePressed() 
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func configure(cell: BalanceHistoryCell, at index: IndexPath)
}

protocol BillingDataTransitions {
     
}

protocol RangeButtonDelegate {
    func showRangePressed()
}

// Wallet Screen

protocol WalletViewProtocol: ShowErrorCapable, ShowAlertCapable, LocalizableScreen, ShowHudCapable {
    var presenter: WalletEvents? {get set}
    func updateExchangeDepositLabel(with string: String)
    func updateRMBLabel(with string: String)
    func loadWebView(string: String)
}

protocol WalletEvents {
    var pickerDataSource: [String]? { get set }
    var pickerBankDataSource: [BankPikerEntry]?  { get set }
    func walletViewIsReady()
    func forceLocalizeUpdatePicker()
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

protocol SettingsViewProtocol: ShowErrorCapable, LocalizableScreen {
    var presenter: SettingsEvents? {get set}
    func updateloginAndSighOutLabel(with text: String)
}

protocol SettingsEvents {
    var languageDataSource: [Language] {get set}
    var legalInfoDataSource: [LegalInformation] {get set}
    func settingsViewIsReady()
    func profileChosen()
    func howToTradeTapped()
    func configure(cell: LanguageCell, at index: Int)
    func configure(cell: LegalInfoCell, at index: Int)
    func chosenLanguage(at index: Int)
    func showLegalInfoItem(at index: Int)
    func lastSectionTapped()
}

protocol SettingsTransitions {
    func goToProfile()
    func showCarousel()
    func languageChanged()
    func goToHome()
    func goToSafariWith(url: URL)
    func signIn()
    func logout()
}

// Profile details Screen

protocol ProfileDetailsViewProtocol: LocalizableScreen {
    var presenter: ProfileDetailsEvents? {get set}
}

protocol ProfileDetailsEvents: LanguageObserver {
    func textFor(textField: UserDetailsTextFields) -> String 
    func saveDetails()
}

protocol ProfileDetailsTransitions {
     func saveDetails()
}
