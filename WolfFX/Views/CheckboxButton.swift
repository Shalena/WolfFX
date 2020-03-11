//
//  CheckboxButton.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/11/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class CheckboxButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib();
        setImage(R.image.selectedCheckBox(), for: .selected)
        setImage(R.image.unselectedCheckBox(), for: .normal)
        addTarget(self, action: #selector(checkBoxPressed(_:)), for: .touchUpInside)
    }
    
    @objc func checkBoxPressed(_ sender: CheckboxButton) {
        sender.isSelected = !sender.isSelected
    }
}
