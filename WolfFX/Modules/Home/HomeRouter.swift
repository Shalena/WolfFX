//
//  HomeRouter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/7/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Swinject

let depositTab = 2

class HomeRouter: BaseRouter, HomeTransitions {
    
    func userHadSuccessfullyLoggedIn() {
        assembler.repository.userHadFirstLogin = true
    }
    
    func loginFailed() {
        assembler.repository.cleanKeychain()
        setupLoginScreen()
    }
    
    private func setupLoginScreen() {
        let window = UIApplication.shared.windows[0]
        guard let loginScreen = R.storyboard.login.loginViewController() else { return }
        let configurator = LoginConfigurator()
        configurator.configure(viewController: loginScreen, with: assembler)
        let loginNavController = UINavigationController(rootViewController: loginScreen)
        window.rootViewController = loginNavController
    }
    
    func goToDeposit() {
        let tabbar = sourceController.tabBarController
        tabbar?.selectedIndex = depositTab
    }
    
    func appHadFirstLaunch() {
        if let repository = try? assembler.resolve(AppFirstLaunch.self) {
            repository.appHadLaunched = true
        }
    }
}
