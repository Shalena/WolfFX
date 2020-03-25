//
//  User.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/29/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

struct User: Codable {
    var billingServer: String?
    var  country: String?
    var currency: String?
    var email: String?
    var enabled: Bool?
    var firstName: String?
    var lastName: String?
    var phone: String?
    var tenantId: String?
}

