//
//  HomeViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, ViewControllerDesign {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        setupLoginOverlay()
        setupBaseNavigationDesign()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "dummyhome.png") ?? UIImage())
    }
    
    private func setupLoginOverlay() {
        let loginConfigurator = LoginConfigurator()
        
        if let loginController = R.storyboard.login.loginViewController() {
            let showTabbarCallback: ShowTabbarCallback = {
                self.tabBarController?.tabBar.isHidden = false
            }
            let assembler = Assembler()
            loginConfigurator.configure(viewController: loginController, with: assembler, callBack: showTabbarCallback)
            loginController.willMove(toParent: self)
            view.addSubview(loginController.view)
            self.addChild(loginController)
            loginController.didMove(toParent: self)
        }
    }
}
