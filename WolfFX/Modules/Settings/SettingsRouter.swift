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
     //   let configurator = SettingsConfigurator()
    // configurator.configure(viewController: profileDetailsController, with: assembler)
            sourceController.navigationController?.pushViewController(profileDetailsController, animated: true)
        }
    }
}
