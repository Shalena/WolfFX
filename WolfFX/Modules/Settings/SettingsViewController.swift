//
//  SettingsViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, NavigationDesign, SettingsViewProtocol  {
    @IBOutlet weak var profileDataView: UIView!
    @IBOutlet weak var signOutView: UIView!
    var presenter: SettingsEvents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseNavigationDesign()
        setupGestes()
    }
    
    private func setupGestes() {
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(self.profileTapped(_:)))
        profileDataView.addGestureRecognizer(profileTap)
        let logoutTap = UITapGestureRecognizer(target: self, action: #selector(self.logoutTapped(_:)))
               signOutView.addGestureRecognizer(logoutTap)
    }
   
    @objc private func profileTapped(_ sender: UITapGestureRecognizer? = nil) {
        presenter?.profileChosen()
    }
    
    @objc private func logoutTapped(_ sender: UITapGestureRecognizer? = nil) {
        presenter?.logout()
    }
}

