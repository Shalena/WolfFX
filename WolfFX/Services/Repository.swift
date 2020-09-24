//
//  Repository.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/5/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Locksmith

let storedPassword = "storedPassword"
let userAccount = "WolfFXUser"
let userHadLaunched = "userHadLaunchedOnce"

protocol UserAccessProtocol: class {
    var user: User? { get set }
}

protocol IsFirstLaunchProtocol: class {
    var hadAlreadyLaunched: Bool { get set }
}

protocol StorePasswordProtocol: class {
    var password: String? { get set }
}

class Repository {
    let userDefaults = UserDefaults(suiteName: userAccount)
    private func cleanKeychain() {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: userAccount)
        }
        catch {
            fatalError()
        }
    }

}

extension Repository: IsFirstLaunchProtocol {
    
     var hadAlreadyLaunched: Bool {
        get {
            return userHadLaunchedOnce()
        }
        set {
          setUserLaunchedFirstTime()
        }
    }
    
   private func setUserLaunchedFirstTime() {
        userDefaults?.set(true, forKey: userHadLaunched)
    }
    
    private func userHadLaunchedOnce() -> Bool {
        if let userHadLaunchedOnce = userDefaults?.object(forKey: userHadLaunched) as? Bool {
            return userHadLaunchedOnce
        } else {
            return false
        }
    }
}

extension Repository: StorePasswordProtocol {
    var password: String? {
           get {
                 let dictionary = Locksmith.loadDataForUserAccount(userAccount: userAccount)
                    if let passwordString = dictionary?[storedPassword] as? String {
                        return passwordString
                    } else {
                     return nil
                 }
             }
             
             set {
                if let password = newValue {
                  updateKeychain(with: password)
                } else {
                    cleanKeychain()
                 }
             }
        }
    private func updateKeychain(with password: String) {
        do {
            try Locksmith.updateData(data: [storedPassword : password], forUserAccount: userAccount)
        }
        catch {
            fatalError()
        }
    }

}
