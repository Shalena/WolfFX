//
//  BaseRouter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/7/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class BaseRouter {
    var sourceController: UIViewController
    var assembler: Assembler
    
    init (with sourceController: UIViewController, assembler: Assembler) {
        self.sourceController = sourceController
        self.assembler = assembler
    }
}
