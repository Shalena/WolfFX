//
//  DataReceiver.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/2/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Swinject

class DataReceiver: NSObject {
    static let shared = DataReceiver()
    var assembler: Assembler?
    @objc dynamic var user: User? {
                set {
                    do {
                        let repository = try assembler?.resolve(UserAccessProtocol.self)
                        repository?.user = newValue
                    } catch {
                        return
                    }
                }
    
                get {
                    do {
                        let repository = try assembler?.resolve(UserAccessProtocol.self)
                        return repository?.user
                    } catch {
                        return nil
                    }
                }
            }
    
    @objc dynamic var realBalanceString = ""
}
