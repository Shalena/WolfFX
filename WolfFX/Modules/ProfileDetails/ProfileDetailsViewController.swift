//
//  ProfileDetailsViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/27/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class ProfileDetailsViewController: UIViewController, ProfileDetailsViewProtocol, NavigationDesign {
    @IBOutlet weak var saveButton: SubmitButton!
    var presenter: ProfileDetailsEvents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseNavigationDesign()
        saveButton.setup(backColor: .clear, borderColor: .gray, text: "Save", textColor: .gray)
    }   
}
