//
//  OrdersJsonAcception.swift
//  WolfFX
//
//  Created by Елена Острожинская on 11/10/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

let orders = "orders"

class OrdersJsonAcception: JsonAcception {
    func acceptJson(json: JSON) -> Bool {
        if let ordersArray = json[orders] as? [JSON] {
            var orders = [Order]()
            for json in ordersArray {
                let jsonstring = Converter().jsonToString(json: json)
                if let jsonData = jsonstring?.data(using: .utf8) {
                    if let order = try? JSONDecoder().decode(Order.self,from: jsonData) {
                        orders.append(order)
                    }
                }            
            }
            WSManager.shared.dataReceiver.orders = orders
        }
        return true
    }
}
