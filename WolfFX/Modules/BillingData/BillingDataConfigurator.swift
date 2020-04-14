//
//  BillingDataConfigurator.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/11/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Swinject

class BillingDataConfigurator {
    func configure(viewController: BillingDataViewController, with assembler: Assembler) {
        let networkManager = assembler.resolveForced(NetworkAccess.self)
        let router = BillingDataRouter(with: viewController, assembler: assembler)
        router.sourceController = viewController
        let presenter = BillingDataPresenter(with: viewController, networkManager: networkManager, router: router)
        viewController.presenter = presenter
    }
}
