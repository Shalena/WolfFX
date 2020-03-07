//
//  Repository.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/5/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Locksmith

let currentUserKey = "currentUserString"
let userAccount = "WolfFXUser"
let userHadLaunched = "userHadLaunchedOnce"

protocol UserAccessProtocol: class {
    var user: User? { get set }
}

protocol IsFirstLaunchProtocol: class {
    var hadAlreadyLaunched: Bool { get set }
}

class Repository {
    let userDefaults = UserDefaults(suiteName: userAccount)
}

extension Repository: UserAccessProtocol {
    
    var user: User? {
        get {
            let dictionary = Locksmith.loadDataForUserAccount(userAccount: userAccount)
            let userJSON = dictionary?[currentUserKey] as? String
            if let userData = userJSON?.data(using: .utf8), let user = try? JSONDecoder().decode(User.self, from: userData) {
                return user
            } else {
                return nil
            }
        }
        
        set {
            let user = newValue
            let userData = try? JSONEncoder().encode(user)
            if let data = userData, let userString = String(data: data, encoding: String.Encoding.utf8) {
                updateKeychain(with: userString)
            } else {
                cleanKeychain()
            }
        }
    }
    
    private func updateKeychain(with user: String) {
        do {
            try Locksmith.updateData(data: [currentUserKey : user], forUserAccount: userAccount)
        }
        catch {
            fatalError()
        }
    }
    
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
