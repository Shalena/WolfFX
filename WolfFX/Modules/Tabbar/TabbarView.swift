//
//  TabbarView.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit

class TabbarView: UITabBarController, UITabBarControllerDelegate  {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupDesign()
    }
    override func viewWillAppear(_ animated: Bool) {
//          for item in self.tabBar.items! {
//                  let unselectedItem = [NSAttributedString.Key.foregroundColor: UIColor.green]
//                  let selectedItem = [NSAttributedString.Key.foregroundColor: UIColor.purple]
//
//                         item.setTitleTextAttributes(unselectedItem, for: .normal)
//                         item.setTitleTextAttributes(selectedItem, for: .selected)
//                     }
    }
    
    func setupDesign() {
        tabBar.barTintColor = UIColor.black
        tabBar.tintColor = UIColor.white
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print(viewController)
    }
}
