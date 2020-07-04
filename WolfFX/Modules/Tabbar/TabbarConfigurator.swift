//
//  TabbarConfigurator.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit

class TabbarConfigurator {
    var navControllers = [UINavigationController]()
    
    func configure(tabBar: TabbarView, with selectedIndex: Int, assembler: Assembler) {
        if let homeController = R.storyboard.home.homeViewController() {
            let homeConfigurator = HomeConfigurator()
            homeConfigurator.configure(viewController: homeController, with: assembler)
            let homeNavigationController = UINavigationController(rootViewController: homeController)
            homeNavigationController.tabBarItem = UITabBarItem(title: R.string.localizable.home().localized(), image: R.image.homeTab()?.withTintColor(UIColor.darkGray, renderingMode: .alwaysOriginal), selectedImage: R.image.homeTab())
            navControllers.append(homeNavigationController)
        }
        if let billingController = R.storyboard.billingData.billingDataViewController() {
            let billingConfigurator = BillingDataConfigurator()
            billingConfigurator.configure(viewController: billingController, with: assembler)
            let billingNavigationController = UINavigationController(rootViewController: billingController)
            billingNavigationController.tabBarItem = UITabBarItem(title: R.string.localizable.billingData().localized(), image: R.image.billingTab()?.withRenderingMode(.alwaysOriginal), selectedImage: R.image.billingTab()?.withTintColor(UIColor.red))
            navControllers.append(billingNavigationController)
        }
        if let walletController = R.storyboard.wallet.walletViewController() {
            let walletConfigurator = WalletConfigurator()
            walletConfigurator.configure(viewController: walletController, with: assembler)
            let walletNavigationController = UINavigationController(rootViewController: walletController)
            walletNavigationController.tabBarItem = UITabBarItem(title: R.string.localizable.wallet().localized(), image: R.image.walletTab()?.withRenderingMode(.alwaysOriginal), selectedImage: R.image.walletTab()?.withTintColor(UIColor.red))
            navControllers.append(walletNavigationController)
        }
        if let settingsController = R.storyboard.settings.settingsViewController() {
            let settingsConfigurator = SettingsConfigurator()
            settingsConfigurator.configure(viewController: settingsController, with: assembler)
            let settingsNavigationController = UINavigationController(rootViewController: settingsController)
            settingsNavigationController.tabBarItem = UITabBarItem(title: nil, image: R.image.settings()?.withRenderingMode(.alwaysOriginal), selectedImage: R.image.settings()?.withTintColor(UIColor.red))
                navControllers.append(settingsNavigationController)
              }
        tabBar.viewControllers = navControllers
        tabBar.selectedIndex = selectedIndex
    }
    
    func localizeForce(tabBar: UITabBar) {
        if let home = tabBar.items?[0],
            let billingData = tabBar.items?[1],
            let wallet = tabBar.items?[2] {
                home.title = R.string.localizable.home().localized()
                billingData.title = R.string.localizable.billingData().localized()
                wallet.title = R.string.localizable.wallet().localized()
        }
    }
}
