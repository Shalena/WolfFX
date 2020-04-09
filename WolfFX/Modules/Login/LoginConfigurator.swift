//
//  LoginConfigurator.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/7/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Swinject

typealias ShowTabbarCallback = (() -> Void)

class LoginConfigurator {
    func configure(viewController: LoginViewController, with assembler: Assembler) {
        let networkManager = assembler.resolveForced(NetworkAccess.self)
        let router = LoginRouter(with: viewController, assembler: assembler)
        router.sourceController = viewController
        let presenter = LoginPresenter(with: viewController, networkManager: networkManager, router: router)
        viewController.presenter = presenter
    }
}
