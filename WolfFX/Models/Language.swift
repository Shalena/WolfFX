//
//  Language.swift
//  WolfFX
//
//  Created by Елена Острожинская on 6/8/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
enum Language {
   case english
   case chineese
  
   var title: String {
       switch self {
           case .english:
               return "EN"
           case .chineese:
               return "中"
           }
   }
    
  var systemName: String {
          switch self {
              case .english:
                  return "en"
              case .chineese:
                  return "zh-Hans"
              }
      }
    
   static let all: [Language] = [.english, .chineese]
}
