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
      var entry: ChartDataEntry
      var max: Double 
      var min: Double
      let width: CGFloat
      var view = UIView()
      var duration: Int64
      var orderStatus: OrderStatus
   
    
    func paintWinColor () {
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 3.0
        view.layer.borderColor = UIColor.green.withAlphaComponent(0.7).cgColor
        view.backgroundColor = UIColor.green.withAlphaComponent(0.2)
    }
    
    func paintLooseColor () {
           view.layer.borderWidth = 1.0
           view.layer.cornerRadius = 3.0
           view.layer.borderColor = UIColor.red.withAlphaComponent(0.7).cgColor
           view.backgroundColor = UIColor.red.withAlphaComponent(0.2)
       }
  }


