//
//  SettingsViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, ViewControllerDesign, SettingsViewProtocol  {
    @IBOutlet weak var profileDataView: UIView!
    var presenter: SettingsEvents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseNavigationDesign()
        setupGestes()
    }
    
    private func setupGestes() {
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(self.profileTapped(_:)))
        profileDataView.addGestureRecognizer(profileTap)
    }
   
    @objc private func profileTapped(_ sender: UITapGestureRecognizer? = nil) {
        presenter?.profileChosen()
    }
}

