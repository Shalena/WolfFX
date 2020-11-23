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

class Snapshot: NSObject {
      var startTime: Double
      var max: Double
      var min: Double
      var width: CGFloat
      var view: SnapshotView?
      var duration: Int64
      var orderStatus: OrderStatus
      var isSuccess: Bool
      var orderId: String
    
    
    init (startTime: Double, max: Double, min: Double, width: CGFloat, duration: Int64, orderStatus: OrderStatus, isSuccess: Bool, orderId: String) {
        self.startTime = startTime
        self.max = max
        self.min = min
        self.width = width
        self.duration = duration
        self.orderStatus = orderStatus
        self.isSuccess = isSuccess
        self.orderId = orderId
    }
  }


