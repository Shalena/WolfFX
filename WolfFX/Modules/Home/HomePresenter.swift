//
//  HomePresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/7/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class HomePresenter: HomeEvents {
    var view: HomeViewProtocol?
    var router: HomeTransitions?
    var networkManager: NetworkAccess
    
    init (with networkManager: NetworkAccess) {
        self.networkManager = networkManager
    }
    
    func setupLoginOverlay() {
        router?.setupLoginOverlay()
    }
}
    
