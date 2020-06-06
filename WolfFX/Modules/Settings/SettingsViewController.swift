//
//  SettingsViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, NavigationDesign, SettingsViewProtocol  {
    @IBOutlet weak var profileDataView: UIView!
    @IBOutlet weak var signOutView: UIView!
    @IBOutlet weak var loginAndSighOutLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: SettingsEvents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseNavigationDesign()
        setupGestes()
        presenter?.settingsViewIsReady()
    }
    
    private func setupGestes() {
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(self.profileTapped(_:)))
        profileDataView.addGestureRecognizer(profileTap)
        let logoutTap = UITapGestureRecognizer(target: self, action: #selector(self.lastSectionTapped(_:)))
               signOutView.addGestureRecognizer(logoutTap)
    }
   
    @objc private func profileTapped(_ sender: UITapGestureRecognizer? = nil) {
        presenter?.profileChosen()
    }
    
    @objc private func lastSectionTapped(_ sender: UITapGestureRecognizer? = nil) {
        presenter?.lastSectionTapped()
    }
    
    func updateloginAndSighOutLabel(with text: String) {
        DispatchQueue.main.async {
            self.loginAndSighOutLabel.text = text
        }        
    }
}

extension SettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LanguageCell", for: indexPath) as? LanguageCell {
            return cell
        }
        fatalError()
    }
}

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return languageFlowLayout()
    }
}
