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
        let router = BillingDataRouter(with: viewController, assembler: assembler)
        router.sourceController = viewController
        let presenter = BillingDataPresenter(with: viewController, router: router)
        viewController.presenter = presenter
    }
}
