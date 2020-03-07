//
//  HomeRouter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/7/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Swinject

class HomeRouter: BaseRouter, HomeTransitions {
    func setupLoginOverlay() {
        let loginConfigurator = LoginConfigurator()
        if let loginController = R.storyboard.login.loginViewController() {
             let showTabbarCallback: ShowTabbarCallback = {
                self.sourceController.tabBarController?.tabBar.isHidden = false
             }
             loginConfigurator.configure(viewController: loginController, with: assembler, callBack: showTabbarCallback)
             loginController.willMove(toParent: sourceController)
             sourceController.view.addSubview(loginController.view)
             sourceController.addChild(loginController)
             loginController.didMove(toParent: sourceController)
         }
    }
}
