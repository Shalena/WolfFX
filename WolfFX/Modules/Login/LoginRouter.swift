//
//  LoginRouter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/7/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class LoginRouter: BaseRouter, LoginTransitions {
  
    func signUpPressed () {
        if let signUpController = R.storyboard.login.signupViewController() {
            let configurator = SignupConfigurator()
            configurator.configure(viewController: signUpController, with: assembler)
            sourceController.show(signUpController, sender: sourceController)
        }
    }
    
    // Login has 2 steps: http call is first. If it returns 200OK, then websocket connection starts
    
    func loginFirstStepFinishedSuccessfully(with email: String, password: String) {
        if let repository = try? assembler.resolve(StoreCredentialsProtocol.self) {
            repository.loginEmail = email
            repository.password = password
        }
        DispatchQueue.main.async {
            self.showTabbar()
        }       
    }

    func closeScreen() {
        showTabbar()
    }
    
    func showTabbar() {
        let tabBar = TabbarView()
        let tabBarConfigurator = TabbarConfigurator()
        tabBarConfigurator.configure(tabBar: tabBar, with: 0, assembler: assembler)
        let window = UIApplication.shared.windows[0]
        window.rootViewController = tabBar
    }
}
