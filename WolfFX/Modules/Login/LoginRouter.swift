//
//  LoginRouter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/7/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class LoginRouter: BaseRouter, LoginTransitions {
  
    func signUpPressed () {
        if let signUpController = R.storyboard.login.signupViewController() {
            let configurator = SignupConfigurator()
            configurator.configure(viewController: signUpController, with: assembler)
            sourceController.navigationController?.pushViewController(signUpController, animated: true)
        }
    }
    
    func userDetailsHadReceived() {
        closeScreen()
    }

    func closeScreen() {
       DispatchQueue.main.async {
            self.sourceController.removeFromParent()
            self.sourceController.view.removeFromSuperview()
        }
    }
}
