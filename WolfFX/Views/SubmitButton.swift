//
//  SubmitButton.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/29/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class SubmitButton: UIButton {
    
override func awakeFromNib() {
    super.awakeFromNib();
    layer.cornerRadius = 5
    layer.borderWidth = 2
    layer.borderColor = UIColor.clear.cgColor
}    
    func setup(backColor: UIColor, borderColor: UIColor, text: String, textColor: UIColor) {
        backgroundColor = backColor
        layer.borderColor = borderColor.cgColor
        setTitle(text, for: .normal)
        setTitleColor(textColor, for: .normal)
    }
}
