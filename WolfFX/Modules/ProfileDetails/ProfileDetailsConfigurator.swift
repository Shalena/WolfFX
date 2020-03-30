//
//  ProfileDetailsConfigurator.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/28/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Swinject

class ProfileDetailsConfigurator {
    func configure(viewController: ProfileDetailsViewController, with assembler: Assembler) {
        let websocketManager = assembler.resolveForced(WebsocketAccess.self)
        let router = ProfileDetailsRouter(with: viewController, assembler: assembler)
        let presenter = ProfileDetailsPresenter.init(with: websocketManager, currentUser: assembler.user, router: router)
        viewController.presenter = presenter
        presenter.view = viewController
    }
}
