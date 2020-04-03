//
//  Currency.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/3/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

enum Currency: String {
    case greatBritainPound = "GBP"
    case unitedStatesDollar = "USD"
    case euro = "EUR"
    
    var title: String {
        switch self {
            case .greatBritainPound:
                return "British Pound"
            case .unitedStatesDollar:
                return "United States Dollar"
            case .euro:
                return "Euro"
            }
    }
        
    var sign: String {
        switch self {
            case .greatBritainPound:
                return "£"
            case .unitedStatesDollar:
                return "$"
            case .euro:
                return "€"
            }
        }
    static let all: [Currency] = [.greatBritainPound, .unitedStatesDollar, .euro]
 }
 
