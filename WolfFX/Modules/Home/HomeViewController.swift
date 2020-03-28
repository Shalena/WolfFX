//
//  HomeViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, NavigationDesign, HomeViewProtocol {
    var presenter: HomeEvents?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        setupLoginOverlay()
        setupBaseNavigationDesign()
    }
    
    private func setupLoginOverlay() {
        presenter?.setupLoginOverlay()
    }
}
