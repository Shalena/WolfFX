//
//  ResetPasswordRouter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 12/7/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class ResetPasswordRouter: BaseRouter, ResetPasswordTransitions {
    func resetWasSentSuccessfully() {
        sourceController.navigationController?.popViewController(animated: true)
    }
}
