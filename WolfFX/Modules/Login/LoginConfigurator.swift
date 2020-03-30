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
    func configure(viewController: LoginViewController, with assembler: Assembler, callBack: @escaping ShowTabbarCallback) {
        let networkManager = assembler.resolveForced(NetworkAccess.self)
        let websocketManager = assembler.resolveForced(WebsocketAccess.self)
        let router = LoginRouter(with: viewController, assembler: assembler)
        router.sourceController = viewController
        router.callback = callBack
        let presenter = LoginPresenter(with: networkManager, websocketManager: websocketManager, store: assembler.store, router: router)
        viewController.presenter = presenter
        presenter.view = viewController
    }
}
