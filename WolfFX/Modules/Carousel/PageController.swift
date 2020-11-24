//
//  CarouselPageController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 11/23/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

let startPresentationIndex = 0

class PageViewController: UIPageViewController {
    
    var controllers = [UIViewController]()
    var currentIndex = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
       
        setViewControllers([controllers[0]], direction: .forward, animated: false, completion: nil)
        setupPageControlDesign()
    }
    
    // Duct tape for removing black stripe for iPhoneX, XS, XR
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        if let scrollView = view.subviews.filter({ $0 is UIScrollView }).first,
//            let pageControl = view.subviews.filter({ $0 is UIPageControl }).first {
//            scrollView.frame = view.bounds
//            view.bringSubviewToFront(pageControl)
//        }
//    }
}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController) {
            if index > 0 {
                return controllers[index - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController) {
            if index < controllers.count - 1 {
                return controllers[index + 1]
            }
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return controllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return startPresentationIndex
    }
    
    private func setupPageControlDesign() {
        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [PageViewController.self])
        appearance.backgroundColor = UIColor.clear
        appearance.pageIndicatorTintColor = UIColor.darkGray
        appearance.currentPageIndicatorTintColor = UIColor.red
    }
}
