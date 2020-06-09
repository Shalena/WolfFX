//
//  Extensions.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/28/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    func fixInView(_ container: UIView!) -> Void{
         self.translatesAutoresizingMaskIntoConstraints = false;
         self.frame = container.frame;
         container.addSubview(self);
         NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
         NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
         NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
         NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
     }
}

extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

extension UIViewController {

    func removeChild() {
        self.children.forEach {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
    
    func languageFlowLayout () -> CGSize {
        let width = (UIScreen.main.bounds.width - 40) / 2 // 40 = 4 paddings with value 10
        let height = CGFloat(50.00) // good looking for 2 languages, should be calcalated when we have more languages
        return CGSize(width: width, height: height)
    }
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }

    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

extension UISegmentedControl {
    func defaultConfiguration(font: UIFont = UIFont.systemFont(ofSize: 12), color: UIColor = UIColor.white) {
        let defaultAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }

    func selectedConfiguration(font: UIFont = UIFont.boldSystemFont(ofSize: 12), color: UIColor = UIColor.red) {
        let selectedAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}

extension Array {
    var middle: Element? {
        guard count != 0 else { return nil }
        let middleIndex = (count > 1 ? count - 1 : count) / 2
        return self[middleIndex]
    }
}
