//
//  LoginPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/2/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class LoginPresenter {
    var networkManager = NetwokManager()
    var view: UIViewController?
    
    init(view: UIViewController) {
        self.view = view        
    }
    
     func signIn(email: String, password: String) {
  
       networkManager.login(email: email, password: password, success: { (user: User?) in
                  if let customer = user {
                     
                  } else {
                      fatalError()
                  }
              }, failure: { [weak self] error in
                  if let error = error {
                    let alert = UIAlertController.init(title: "Error", message: error.errorDescription, preferredStyle: .alert)
                    self?.view?.show(alert, sender: self?.view)
                  }
              })
        
    }
}
