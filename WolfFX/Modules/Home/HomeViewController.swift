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
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.homeViewIsReady()
    }
    
     func setupLoginOverlay() {
        presenter?.setupLoginOverlay()
    }
}
