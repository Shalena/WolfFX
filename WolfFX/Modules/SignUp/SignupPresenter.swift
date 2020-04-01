//
//  SignupPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/11/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import ReSwift

struct RegistrationForm {
    var firstName: String?
    var email: String?
    var emails: [String]?
    var password: String?
    var isTerms: Bool
    var currency: String?
    var tenantId: String?
}

class SignupPresenter: SignupEvents, StoreSubscriber {
    var view: SignupViewProtocol?
    var router: SignupTransitions?
    var networkManager: NetworkAccess
    var websocketManager: WebsocketAccess
    
    init (with networkManager: NetworkAccess, websocketManager: WebsocketAccess,  store: Store<AppState>) {
        self.networkManager = networkManager
        self.websocketManager = websocketManager
        store.subscribe(self) { $0.select { $0.cState } }
    }
    
    func newState(state: CustomerState) {
        
    }
        
    func registerUserWith(form: RegistrationForm) {
        if validatedSuccessfully(form: form) {
            networkManager.signup(firstname: form.firstName ?? "", currency: form.currency ?? "", emails: form.emails ?? [String](), password: form.password ?? "", tenantId: form.tenantId ?? "", username: form.email ?? "", success: { (successfully: Bool) in
                    if successfully {
                        self.websocketManager.connect()
                        self.websocketManager.getUserInfo()
                        self.userHadCreated()
                    }
                }, failure: { [weak self] error in
                    if let error = error {
                      self?.view?.showErrorAlertWith(error: error)
                    }
                })
        }
    }
    
    func userHadCreated() {
        router?.removeOverlayAndShowHome()
    }
    
    func validatedSuccessfully(form: RegistrationForm) -> Bool {
        let registrationValidation = Validation()
        let fieldsResponse = registrationValidation.validate(fields: (FieldsValidationType.firstName, form.firstName ?? ""),
                                                                      (FieldsValidationType.email, form.email ?? ""),
                                                                      (FieldsValidationType.password, form.password ?? ""))
        switch fieldsResponse {
        case .success:
            break
        case .failure(_, let message):
            view?.showErrorAlertWith(error: WolfError(description: message.rawValue))
            return false
        }
        let checkBoxResponse = registrationValidation.validate(checkboxes: (type: CheckboxesValidationType.termsSelected, inputValue: form.isTerms))
        switch checkBoxResponse {
        case .success:
            break
        case .failure(_, let message):
            view?.showErrorAlertWith(error: WolfError(description: message.rawValue))
            return false
        }
        return true
    }
}
