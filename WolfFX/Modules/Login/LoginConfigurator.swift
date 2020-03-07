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
    func configure(viewController: LoginViewController, with assembler: Assembler, callBack: ShowTabbarCallback) {
        let networkManager = assembler.resolveForced(NetworkAccess.self)
        let presenter = LoginPresenter(with: networkManager)
        let router = LoginRouter(with: viewController, assembler: assembler)
        router.sourceController = viewController
        presenter.router = router
        viewController.presenter = presenter
        presenter.view = viewController
    }
}
