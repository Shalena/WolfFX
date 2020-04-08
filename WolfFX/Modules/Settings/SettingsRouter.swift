//
//  SettingsRouter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/27/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class SettingsRouter: BaseRouter, SettingsTransitions {
    func goToProfile() {
        if let profileDetailsController = R.storyboard.settings.profileDetailsViewController() {
            let configurator = ProfileDetailsConfigurator()
            configurator.configure(viewController: profileDetailsController, with: assembler)
            sourceController.navigationController?.pushViewController(profileDetailsController, animated: true)
        }
    }
    
    func logout() {
        DataReceiver.shared.user = nil
        if let home = sourceController.tabBarController?.children[0].children[0] as? HomeViewController {
            sourceController.tabBarController?.selectedIndex = 0
            home.setupLoginOverlay()
        }
    }
}
