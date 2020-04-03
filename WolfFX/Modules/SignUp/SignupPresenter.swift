//
//  SignupPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/11/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

struct RegistrationForm {
    var firstName: String?
    var email: String?
    var emails: [String]?
    var password: String?
    var isTerms: Bool
    var currency: String?
    var tenantId: String?
}

class SignupPresenter: NSObject, SignupEvents {
    var view: SignupViewProtocol?
    var router: SignupTransitions?
    var networkManager: NetworkAccess
    var websocketManager: WebsocketAccess
    @objc dynamic var dataReceiver: DataReceiver?
    var observation: NSKeyValueObservation?
    
    init (with view: SignupViewProtocol, networkManager: NetworkAccess) {
        self.view = view
        self.networkManager = networkManager
        self.websocketManager = WSManager.shared
    }
    
    func observe() {
           observation = observe(\.dataReceiver?.user,
                      options: [.old, .new]
                  ) { object, change in
                     self.userHadCreated()
                  }
       }
    
    func registerUserWith(form: RegistrationForm) {
        if validatedSuccessfully(form: form) {
            networkManager.signup(firstname: form.firstName ?? "", currency: form.currency ?? "", emails: form.emails ?? [String](), password: form.password ?? "", tenantId: form.tenantId ?? "", username: form.email ?? "", success: { (successfully: Bool) in
                    if successfully {
                        self.websocketManager.connect()
                        self.websocketManager.getUserInfo()
                    }
                }, failure: { [weak self] error in
                    if let error = error {
                      self?.view?.showErrorAlertWith(error: error)
                    }
                })
        }
    }
    
    func userHadCreated() {
        router?.userHadCreated()
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
