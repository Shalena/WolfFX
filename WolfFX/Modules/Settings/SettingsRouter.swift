//
//  SettingsRouter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/27/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class SettingsRouter: BaseRouter, SettingsTransitions {
    func goToHome() {
        sourceController.tabBarController?.selectedIndex = 0
    }
    
    func goToProfile() {
        if let profileDetailsController = R.storyboard.settings.profileDetailsViewController() {
            let configurator = ProfileDetailsConfigurator()
            configurator.configure(viewController: profileDetailsController, with: assembler)
            sourceController.navigationController?.pushViewController(profileDetailsController, animated: true)
        }
    }
    
    func goToSafariWith(url: URL) {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: url, configuration: config)
        sourceController.present(vc, animated: true)
    }
    
    func logout() {
        DataReceiver.shared?.user = nil
        let window = UIApplication.shared.windows[0]
        guard let loginScreen = R.storyboard.login.loginViewController() else { return }
        let configurator = LoginConfigurator()
        configurator.configure(viewController: loginScreen, with: assembler)
        window.rootViewController = loginScreen
    }
}
