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
            sourceController.show(signUpController, sender: sourceController)
        }
    }
    
    func userDetailsHadReceived() {
        DispatchQueue.main.async {
            self.showTabbar()
        }       
    }

    func closeScreen() {
        self.sourceController.removeFromParent()
        self.sourceController.view.removeFromSuperview()      
    }
    
    func showTabbar() {
        let tabBar = TabbarView()
        let tabBarConfigurator = TabbarConfigurator()
        tabBarConfigurator.configure(tabBar: tabBar, with: 0, assembler: assembler)
        sourceController.show(tabBar, sender: self)
    }
}
