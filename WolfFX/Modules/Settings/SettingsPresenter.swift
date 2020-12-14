//
//  SettingsPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/27/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

enum LoginState {
    case userIsLoggedIn
    case userIsLoggedOut
    
    var text: String {
        switch self {
        case .userIsLoggedIn:
            return R.string.localizable.signOut().localized()
        case .userIsLoggedOut:
            return R.string.localizable.logIn().localized()
        }
    }
}

class SettingsPresenter: NSObject, SettingsEvents {
    var view: SettingsViewProtocol?
    var router: SettingsTransitions?
    var networkManager: NetworkAccess?
    @objc dynamic var dataReceiver: DataReceiver?
    var observation: NSKeyValueObservation?
    var currentLoginState: LoginState?
    var languageDataSource = Language.all
    var legalInfoDataSource = LegalInformation.all
    
    init (with view: SettingsViewProtocol, networkManager: NetworkAccess, router: SettingsTransitions) {
        self.view = view
        self.networkManager = networkManager
        self.router = router
        dataReceiver = WSManager.shared.dataReceiver
    }
    
    func settingsViewIsReady() {
        setupLoginLogoutState()
        observe()
    }
    
    func observe() {
        observation = observe(\.dataReceiver?.user, options: [.old, .new]) { object, change in
            self.setupLoginLogoutState()
       }
    }
    
    func profileChosen() {
        if dataReceiver?.user != nil {
            router?.goToProfile()
        } else {
            router?.goToHome()
        }
    }
    
    func howToTradeTapped() {
        router?.showCarousel()
    }
    
    func lastSectionTapped() {
        switch currentLoginState {
        case .userIsLoggedIn:
            logout()
        case .userIsLoggedOut:
            self.router?.signIn()
        case .none: return
        }
    }
    
    func configure(cell: LanguageCell, at index: Int) {
        let language = languageDataSource[index]
        cell.title.text = language.title
    }
    
    func configure(cell: LegalInfoCell, at index: Int) {
        let legalInfoItem = legalInfoDataSource[index]
        cell.title.text = legalInfoItem.title
    }
    
    func showLegalInfoItem(at index: Int) {
        if let urlString = legalInfoDataSource[index].link,
           let url = URL(string: urlString) {
           router?.goToSafariWith(url: url)
        }
    }
    
    private func setupLoginLogoutState() {
        if WSManager.shared.dataReceiver.user != nil {
            self.currentLoginState = .userIsLoggedIn
        } else {
            self.currentLoginState = .userIsLoggedOut
        }
        view?.updateloginAndSighOutLabel(with: self.currentLoginState?.text ?? "")
    }
    
    private func logout() {
        WSManager.shared.dataReceiver.connectionClosed = true
        WSManager.shared.stop()
        networkManager?.logout(success: { successfully in
            WSManager.shared.dataReceiver.user = nil
            self.router?.logout()
        }, failure: { error in
            if let error = error {
                self.view?.showErrorAlertWith(error: error)
            }
        })
    }
}
