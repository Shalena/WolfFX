//
//  SignupRouter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/11/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class SignupRouter: BaseRouter, SignupTransitions {
    func userHadCreated() {
     DispatchQueue.main.async {
        self.sourceController.navigationController?.popToRootViewController(animated: true)
     }
          
    }
}
