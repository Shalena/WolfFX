//
//  CheckboxButton.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/11/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

typealias CheckBoxCallback = (() -> Void)

class CheckboxButton: UIButton {
    var callback: CheckBoxCallback?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setImage(R.image.selectedCheckBox(), for: .selected)
        setImage(R.image.unselectedCheckBox(), for: .normal)
        addTarget(self, action: #selector(checkBoxPressed(_:)), for: .touchUpInside)
        backgroundColor = .white
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
    @objc func checkBoxPressed(_ sender: CheckboxButton) {
        sender.isSelected = !sender.isSelected
        callback?()
    }
}
