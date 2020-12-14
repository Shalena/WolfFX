//
//  ResetPasswordConfigurator.swift
//  WolfFX
//
//  Created by Елена Острожинская on 12/7/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Swinject

class ResetPasswordConfigurator {
    func configure(viewController: ResetPasswordController, with assembler: Assembler) {
        let networkManager = assembler.resolveForced(NetworkAccess.self)
        let presenter = ResetPasswordPresenter(with: viewController, networkManager: networkManager)
        let router = ResetPasswordRouter(with: viewController, assembler: assembler)
        router.sourceController = viewController
        presenter.router = router
        viewController.presenter = presenter
    }
}
