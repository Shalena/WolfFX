//
//   Assembler.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/5/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Swinject
import ReSwift

class Assembler {
    var container = Container()
    
    func initFlow() {
        register(NetworkAccess.self, name: nil) { _ in NetwokManager()}
        let store = Store<AppState>(reducer: appReducer, state: AppState(with: self))
        register(Store.self, name: nil) { _ in store }
        let websocketManager = WSManager.init(with: store)
        register(WebsocketAccess.self, name: nil) { _ in websocketManager }
        let repository = Repository()
        register(IsFirstLaunchProtocol.self, name: nil) { _ in repository}
        register(UserAccessProtocol.self, name: nil) { _ in repository }
    }
        
    var hadAlreadyLaunched: Bool {
        set {
            do {
                let repository = try resolve(IsFirstLaunchProtocol.self)
                repository?.hadAlreadyLaunched = newValue
            } catch {
                return
            }
        }
        
        get {
            do {
                if let repository = try resolve(IsFirstLaunchProtocol.self) {
                     return repository.hadAlreadyLaunched
                } else {
                    return false
                }
            } catch {
                return false
            }
        }
    }
    
    func register<Service>(
        _ serviceType: Service.Type,
        name: String? = nil,
        factory: @escaping (Resolver) -> Service
        ) {
        container.register(serviceType, name: name, factory: factory)
    }
    
    func resolve<Service>(_ serviceType: Service.Type) throws -> Service? {
        return container.resolve(serviceType)
    }
    
    func resolveForced<Service>(_ serviceType: Service.Type) -> Service {
        if let service = container.resolve(serviceType) {
            return service
        } else {
            fatalError()
        }
    }
}
