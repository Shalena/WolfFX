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
let userHad1stLogin = "userHadFirstLogin"
let firstLaunch = "firstLaunch"

protocol UserAccessProtocol: class {
    var user: User? { get set }
}

protocol FirstLoginProtocol: class {
    var userHadFirstLogin: Bool { get set }
}

protocol StoreCredentialsProtocol: class {
    var loginEmail: String? { get set }
    var password: String? { get set }
}

protocol AppFirstLaunch: class {
    var appHadLaunched: Bool { get set }
}

class Repository {
    let userDefaults = UserDefaults(suiteName: userAccount)
    func cleanKeychain() {
        if Locksmith.loadDataForUserAccount(userAccount: userAccount) != nil {
            do {
                try Locksmith.deleteDataForUserAccount(userAccount: userAccount)
            }
                catch {
                    fatalError()
            }
        }
        userHadFirstLogin = false
    }
}

extension Repository: FirstLoginProtocol {
    
     var userHadFirstLogin: Bool {
        get {
            return userHadLogin()
        }
        set {
           userDefaults?.set(newValue, forKey: userHad1stLogin)
        }
    }
 
    private func userHadLogin() -> Bool {
        if let userHadFirstLogin = userDefaults?.object(forKey: userHad1stLogin) as? Bool {
            return userHadFirstLogin
        } else {
            return false
        }
    }
}
extension Repository: AppFirstLaunch {
    
     var appHadLaunched: Bool {
        get {
            return appLaunched()
        }
        set {
           userDefaults?.set(newValue, forKey: firstLaunch)
        }
    }
 
    private func appLaunched() -> Bool {
        if let hadLaunched = userDefaults?.object(forKey: firstLaunch) as? Bool {
            return hadLaunched
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
                fatalError()
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
                    fatalError()
                 }
             }
        }
    
    private func updateKeychain(loginEmail: String) {
        do {
            try Locksmith.updateData(data: [storedLoginEmail : loginEmail], forUserAccount: userAccount)
        }
            catch {
                fatalError()
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
