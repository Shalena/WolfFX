//
//  BalanceHistoryFooterView.swift
//  WolfFX
//
//  Created by Елена Острожинская on 10/27/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class BalanceHistoryFooterView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var button: SubmitButton!
    let delegate: RangeButtonDelegate?
       
    init(frame: CGRect, sender: RangeButtonDelegate) {
       self.delegate = sender
       super.init(frame: frame)
       commonInit()
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("BalanceHistoryFooterView", owner: self, options: nil)
        contentView.fixInView(self)
        button.setup(backColor: UIColor.clear, borderColor: UIColor.red)
    }
  
    func setButton(title: String) {
        DispatchQueue.main.async {
            self.button.setTitle(title, for: .normal)
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        delegate?.showRangePressed()
    }
}
