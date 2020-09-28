//
//  JsonAcception.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/6/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

let profileKey = "profile"

class UserJsonAcception: JsonAcception {
    func acceptJson(json: JSON) -> Bool {
        if let userjson = json[profileKey] as? JSON {
            let userjsonstring = Converter().jsonToString(json: userjson)
            if let jsonData = userjsonstring?.data(using: .utf8){
                if let user = try? JSONDecoder().decode(User.self, from: jsonData) {
                    print(user)
                    WSManager.shared.dataReceiver.user = user
                }
            }
            return true
         } else {
            return false
        }
    }
}
