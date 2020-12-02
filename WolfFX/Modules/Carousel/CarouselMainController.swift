//
//  CarouselMainController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 11/23/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class CarouselMainController: UIViewController {

    @IBOutlet weak var letsgoButton: SubmitButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        letsgoButton.setTitle(R.string.localizable.letSGo().uppercased(), for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "embedPageSegue" {
        if let childVC = segue.destination as? PageViewController {
            let configurator = CarouselConfigurator()
             configurator.configure(viewController: childVC)
        }
      }
    }
    
    @IBAction func letsgoPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
