//
//  ProfileDetailsPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/28/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class ProfileDetailsPresenter: ProfileDetailsEvents {
   
var view: ProfileDetailsViewProtocol?
var router: ProfileDetailsTransitions?
var websocketManager: WebsocketAccess

    init (with websocketManager: WebsocketAccess) {
        self.websocketManager = websocketManager
    }

    func saveDetails() {
        router?.saveDetails()
    }
}
