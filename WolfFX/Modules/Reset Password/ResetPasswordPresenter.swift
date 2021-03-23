//r
//  ResetPasswordPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 12/7/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class ResetPasswordPresenter: ResetPasswordEvents {
    
    var view: ResetPasswordViewProtocol?
    var router: ResetPasswordTransitions?
    var networkManager: NetworkAccess

    init (with view: ResetPasswordViewProtocol, networkManager: NetworkAccess) {
           self.view = view
           self.networkManager = networkManager
    }
    
    func resetPasswordWith(email: String) {
        view?.showHud()
        networkManager.restorePassword(email: email, success: { (successfully: Bool) in
            if successfully {
                self.view?.hideHud()
                let text = R.string.localizable.weVeSentYouEmail() + "\n" + R.string.localizable.pleaseCheckYourSpam()
                self.view?.showAlertWith(title: nil, message: text, buttonTitle: R.string.localizable.oK(), action: nil)
                self.router?.resetWasSentSuccessfully()
            }
        }, failure: { [weak self] error in
            self?.view?.hideHud()
            if let error = error {
              self?.view?.showErrorAlertWith(error: error)
            }
        })
    }
}
