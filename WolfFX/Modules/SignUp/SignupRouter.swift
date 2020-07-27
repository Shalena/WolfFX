//
//  SignupRouter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/11/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class SignupRouter: BaseRouter, SignupTransitions {
    func registrationFinishedSuccessfully() {
        DispatchQueue.main.async {
            self.showTabbar()
        }
    }
    
   private func showTabbar() {
           let tabBar = TabbarView()
           let tabBarConfigurator = TabbarConfigurator()
           tabBarConfigurator.configure(tabBar: tabBar, with: 0, assembler: assembler)
           let window = UIApplication.shared.windows[0]
           window.rootViewController = tabBar
       }
}
