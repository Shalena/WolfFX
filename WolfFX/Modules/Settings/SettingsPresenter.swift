//
//  SettingsPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/27/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class SettingsPresenter: SettingsEvents {
    var view: SettingsViewProtocol?
    var router: SettingsTransitions?
    
    func profileChosen() {
        router?.goToProfile()
    }
}
