//
//  SnapshotView.swift
//  WolfFX
//
//  Created by Елена Острожинская on 11/19/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class SnapshotView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         self.setupDesign()
     }
    
    private func setupDesign() {
        super.awakeFromNib()
        layer.borderWidth = 2.0
        layer.cornerRadius = 3.0
        layer.masksToBounds = true
    }
    
    func paintWinColor () {
        layer.borderColor = UIColor.green.cgColor
        backgroundColor = UIColor.green.withAlphaComponent(0.5)
    }

    func paintLooseColor () {
        layer.borderColor = UIColor.red.cgColor
        backgroundColor = UIColor.red.withAlphaComponent(0.5)
    }
}


