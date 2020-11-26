//
//  CarouselConfigurator.swift
//  WolfFX
//
//  Created by Елена Острожинская on 11/23/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//


import Foundation
import UIKit

class CarouselConfigurator {
    
    func configure(viewController: PageViewController) {
        if let firstPageController = R.storyboard.carousel.firstPageController() ,
            let secondPageController = R.storyboard.carousel.secondPageController(),
            let thirdPageController = R.storyboard.carousel.thirdPageController(),
            let fourthPageController = R.storyboard.carousel.fourthPageController(),
            let fifthPageController = R.storyboard.carousel.fifthPageController(),
            let sixthPageController = R.storyboard.carousel.sixthPageController(),
            let seventhPageController = R.storyboard.carousel.seventhPageController() {
            let controllers = [firstPageController, secondPageController, thirdPageController, fourthPageController, fifthPageController, sixthPageController, seventhPageController]
            viewController.controllers = controllers
        }
    }
}
