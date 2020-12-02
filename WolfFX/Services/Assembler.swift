//
//   Assembler.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/5/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Swinject

class Assembler {
    var container = Container()
    var repository = Repository()
    
    func initFlow() {
        register(NetworkAccess.self, name: nil) { _ in NetwokManager()}
        register(FirstLoginProtocol.self, name: nil) { _ in self.repository}
        register(StoreCredentialsProtocol.self, name: nil) { _ in self.repository }
        register(AppFirstLaunch.self, name: nil) { _ in self.repository}
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
    
    func cleanStoredValues() {
        repository.cleanKeychain()
    }
    
}
