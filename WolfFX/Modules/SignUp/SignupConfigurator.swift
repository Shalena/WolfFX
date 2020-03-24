//
//  SignupConfigurator.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/11/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Swinject

class SignupConfigurator {
    func configure(viewController: SignupViewController, with assembler: Assembler) {
        let networkManager = assembler.resolveForced(NetworkAccess.self)
        let websocketManager = assembler.resolveForced(WebsocketAccess.self)
        let presenter = SignupPresenter(with: networkManager, websocketManager: websocketManager)
        let router = SignupRouter(with: viewController, assembler: assembler)
        router.sourceController = viewController
        presenter.router = router
        viewController.presenter = presenter
        presenter.view = viewController
    }
}
