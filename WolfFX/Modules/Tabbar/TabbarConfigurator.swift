//
//  TabbarConfigurator.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit

let indexOfHomeTab = 0

class TabbarConfigurator {
    var navControllers = [UINavigationController]()
    
    func configure(tabBar: TabbarView, with selectedIndex: Int, assembler: Assembler) {
        if let homeController = R.storyboard.home.homeViewController() {
            let homeNavigationController = UINavigationController(rootViewController: homeController)
            homeNavigationController.tabBarItem = UITabBarItem(title: "Home", image: R.image.homeTab()?.withTintColor(UIColor.darkGray, renderingMode: .alwaysOriginal), selectedImage: R.image.homeTab())
            navControllers.append(homeNavigationController)
        }
        if let billingController = R.storyboard.billingData.billingDataViewController() {
            let billingNavigationController = UINavigationController(rootViewController: billingController)
            billingNavigationController.tabBarItem = UITabBarItem(title: "Billing data", image: R.image.billingTab()?.withRenderingMode(.alwaysOriginal), selectedImage: R.image.billingTab())
            navControllers.append(billingNavigationController)
        }
        if let walletController = R.storyboard.wallet.walletViewController(){
                  let walletNavigationController = UINavigationController(rootViewController: walletController)
                  walletNavigationController.tabBarItem = UITabBarItem(title: "Wallet", image: R.image.walletTab()?.withRenderingMode(.alwaysOriginal), selectedImage: R.image.walletTab())
                  navControllers.append(walletNavigationController)
              }
        if let settingsController = R.storyboard.settings.settingsViewController() {
                  let settingsNavigationController = UINavigationController(rootViewController: settingsController)
            settingsNavigationController.tabBarItem = UITabBarItem(title: "Settings", image: R.image.settings()?.withRenderingMode(.alwaysOriginal), selectedImage: R.image.settings()?.withTintColor(UIColor.red))
                  navControllers.append(settingsNavigationController)
              }
        tabBar.viewControllers = navControllers
        tabBar.selectedIndex = selectedIndex
    }
}
