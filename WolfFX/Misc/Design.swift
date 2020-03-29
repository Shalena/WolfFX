//
//  Design.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/26/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit

extension NavigationDesign where Self: UIViewController {
    func setupBaseNavigationDesign() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
    }
}

extension NavigationBackButtonDesign where Self: UIViewController {
    func setupBackButton() {
       let imgBack = R.image.arrowLeft()?.withRenderingMode(.alwaysOriginal)
       navigationController?.navigationBar.backIndicatorImage = imgBack
       navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBack
       navigationItem.leftItemsSupplementBackButton = true
       navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
}
