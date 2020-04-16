//
//  WalletViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController, NavigationDesign  {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var depositView: UIView!
    @IBOutlet weak var withdrawView: UIView!
    @IBOutlet weak var continueButton: SubmitButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
    }
    
    func setupDesign() {
        setupBaseNavigationDesign()
        segment.defaultConfiguration()
        withdrawView.isHidden = true
        continueButton.setup(backColor: .red, borderColor: .red, text: "CONTINUE", textColor: .black)
    }
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        switch segment.selectedSegmentIndex {
            case 0:
                depositView.isHidden = false
                withdrawView.isHidden = true
            case 1:
                depositView.isHidden = true
                withdrawView.isHidden = false
           
            default:
                break
            }
        }
    
    @IBAction func depositContinuePressed(_ sender: Any) {
        
    }
}
