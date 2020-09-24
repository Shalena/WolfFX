//
//  Repository.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/5/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Locksmith

let storedLoginEmail = "storedLoginEmail"
let storedPassword = "storedPassword"
let userAccount = "WolfFXUser"
let userHadLaunched = "userHadLaunchedOnce"

protocol UserAccessProtocol: class {
    var user: User? { get set }
}

protocol IsFirstLaunchProtocol: class {
    var hadAlreadyLaunched: Bool { get set }
}

protocol StoreCredentialsProtocol: class {
    var loginEmail: String? { get set }
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

extension Repository: StoreCredentialsProtocol {
    var loginEmail: String? {
       get {
             let dictionary = Locksmith.loadDataForUserAccount(userAccount: userAccount)
                if let loginEmailString = dictionary?[storedLoginEmail] as? String {
                    return loginEmailString
                } else {
                 return nil
             }
         }
         
         set {
            if let loginEmail = newValue {
              updateKeychain(loginEmail: loginEmail)
            } else {
                cleanKeychain()
             }
         }
    }
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
                  updateKeychain(password: password)
                } else {
                    cleanKeychain()
                 }
             }
        }
    
    private func updateKeychain(loginEmail: String) {
        if var currentData = Locksmith.loadDataForUserAccount(userAccount: userAccount) as? [String: String] {
            do {
                currentData[storedLoginEmail] = loginEmail
                try Locksmith.updateData(data: currentData, forUserAccount: userAccount)
            } catch {
                fatalError()
            }
        }
    }
    
    private func updateKeychain(password: String) {
        if var currentData = Locksmith.loadDataForUserAccount(userAccount: userAccount) as? [String: String] {
            do {
                currentData[storedPassword] = password
                try Locksmith.updateData(data: currentData, forUserAccount: userAccount)
            } catch {
                fatalError()
            }
        }
    }
}
