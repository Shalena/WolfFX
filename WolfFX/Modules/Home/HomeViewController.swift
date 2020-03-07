//
//  HomeViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, ViewControllerDesign, HomeViewProtocol {
    var presenter: HomeEvents?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        setupLoginOverlay()
        setupBaseNavigationDesign()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "dummyhome.png") ?? UIImage())
    }
    
    private func setupLoginOverlay() {
        presenter?.setupLoginOverlay()
    }
}
