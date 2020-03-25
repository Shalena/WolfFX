//
//  Redux.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import ReSwift

enum SignInAction: Action {
    case signIn(user: User)
    case register(user: User)
    case signOut
}

struct CustomerState: StateType {
    private var assembler: Assembler?
    
    var customer: User? {
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
    
    init(with assembler: Assembler? = nil) {
       self.assembler = assembler
    }
}

struct AppState: StateType {
    private var assembler: Assembler?
    
    fileprivate(set) var cState: CustomerState
    
    init(with assembler: Assembler? = nil) {
        self.assembler = assembler
        self.cState = CustomerState(with: assembler)
    }
    
    fileprivate init(state: AppState) {
        self.assembler = state.assembler
        self.cState = state.cState
    }
}

func appReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    
    switch action {
        case SignInAction.signIn(let customer) as SignInAction:
            state.cState.customer = customer
        case SignInAction.register(let customer) as SignInAction:
            state.cState.customer = customer
        case SignInAction.signOut:
            state.cState.customer = nil
    default:
        break
    }

    return state
}
