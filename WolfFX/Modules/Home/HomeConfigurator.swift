//
//  HomeConfigurator.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/7/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Swinject

class HomeConfigurator {
    func configure(viewController: HomeViewController, with assembler: Assembler) {
        let networkManager = assembler.resolveForced(NetworkAccess.self)
        let presenter = HomePresenter(with: networkManager)
        let router = HomeRouter(with: viewController, assembler: assembler)
        router.sourceController = viewController
        presenter.router = router
        viewController.presenter = presenter
        presenter.view = viewController
        if let repository = try? assembler.resolve(StorePasswordProtocol.self) {
            print(repository.password)
            
        }
    }
}
