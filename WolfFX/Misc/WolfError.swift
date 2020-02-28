//
//  WolfError.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/29/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

protocol WolfErrorProtocol: LocalizedError {
   
}

struct WolfError: WolfErrorProtocol {
    var errorDescription: String?

    init(description: String) {
        self.errorDescription = description
    }
}
