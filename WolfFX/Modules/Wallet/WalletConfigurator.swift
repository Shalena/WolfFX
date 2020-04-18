//
//  Wallet.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/18/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Swinject

class WalletConfigurator {
    func configure(viewController: WalletViewController, with assembler: Assembler) {
        let networkManager = assembler.resolveForced(NetworkAccess.self)
        let router = WalletRouter(with: viewController, assembler: assembler)
        router.sourceController = viewController
        let presenter = WalletPresenter(with: viewController, networkManager: networkManager, router: router)
        viewController.presenter = presenter
    }
}
