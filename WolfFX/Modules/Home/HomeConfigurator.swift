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
        if let repository = try? assembler.resolve(FirstLoginProtocol.self) {
            presenter.shouldPerformHTTPLogin = repository.userHadFirstLogin
            setupCredentials(assembler: assembler, presenter: presenter)
        }
        if let repository = try? assembler.resolve(AppFirstLaunch.self) {
            presenter.shouldShowHowToTrade = !repository.appHadLaunched            
        }
    }
    
    private func setupCredentials(assembler: Assembler, presenter: HomePresenter) {
        if let repository = try? assembler.resolve(StoreCredentialsProtocol.self) {
            if let loginEmail = repository.loginEmail, let password = repository.password {
                let credentials = Credentials(loginEmail: loginEmail, password: password)
                presenter.credentials = credentials
            }
        }
    }
}
