//
//  SettingsConfigurator.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/27/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Swinject

class SettingsConfigurator {
    func configure(viewController: SettingsViewController, with assembler: Assembler) {
        let networkManager = assembler.resolveForced(NetworkAccess.self)
        let router = SettingsRouter(with: viewController, assembler: assembler)
        router.sourceController = viewController
        let presenter = SettingsPresenter(with: viewController, networkManager: networkManager, router: router)
        viewController.presenter = presenter
    }
}
