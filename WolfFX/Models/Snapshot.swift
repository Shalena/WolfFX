//
//  Snapshot.swift
//  WolfFX
//
//  Created by Елена Острожинская on 8/15/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit
import Charts

struct Snapshot {
      var index: Int
      let width: CGFloat
      var view = UIView()
     
    func paintWinColor () {
        view.layer.borderColor = UIColor.green.withAlphaComponent(0.7).cgColor
        view.backgroundColor = UIColor.green.withAlphaComponent(0.2)
    }
    
    func paintLooseColor () {
           view.layer.borderColor = UIColor.red.withAlphaComponent(0.7).cgColor
           view.backgroundColor = UIColor.red.withAlphaComponent(0.2)
       }
  }


