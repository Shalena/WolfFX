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
    @IBOutlet weak var languageHeaderView: UIView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var languageArrow: UIImageView!
    @IBOutlet weak var settingsTitle: UILabel!
    @IBOutlet weak var profileData: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var support: UILabel!
    @IBOutlet weak var howToTrade: UILabel!
    @IBOutlet weak var legalInformation: UILabel!    
    
    var languageViewIsHidden = true
    var presenter: SettingsEvents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseNavigationDesign()
        setupGestes()
        presenter?.settingsViewIsReady()
        localize()
    }
    
    private func setupGestes() {
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(self.profileTapped(_:)))
        profileDataView.addGestureRecognizer(profileTap)
        let logoutTap = UITapGestureRecognizer(target: self, action: #selector(self.lastSectionTapped(_:)))
               signOutView.addGestureRecognizer(logoutTap)
        let languageTap = UITapGestureRecognizer(target: self, action: #selector(self.languageTapped(_:)))
        languageHeaderView.addGestureRecognizer(languageTap)
    }
    
    func localize() {
         settingsTitle.text = R.string.localizable.settings()
         profileData.text = R.string.localizable.profileData()
         language.text = R.string.localizable.language()
         support.text = R.string.localizable.support()
         howToTrade.text = R.string.localizable.howToTrade()
         legalInformation.text = R.string.localizable.legalInformation()
         loginAndSighOutLabel.text = R.string.localizable.logIn()
    }
    
    @objc private func profileTapped(_ sender: UITapGestureRecognizer? = nil) {
        presenter?.profileChosen()
    }
    
    @objc private func lastSectionTapped(_ sender: UITapGestureRecognizer? = nil) {
        presenter?.lastSectionTapped()
    }
    
    @objc private func languageTapped(_ sender: UITapGestureRecognizer? = nil) {
        languageViewIsHidden = !languageViewIsHidden
        languageView.isHidden = languageViewIsHidden
        var angle = CGFloat(0.0)
        if languageViewIsHidden {
            angle = .pi / -2
        } else {
            angle = .pi / 2
        }
        languageArrow.transform = languageArrow.transform.rotated(by: angle)
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
            presenter?.configure(cell: cell, at: indexPath.row)
            return cell
        }
        fatalError()
    }
}

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return languageFlowLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedLanguage = presenter?.languages[indexPath.row]
        print(selectedLanguage)
        
    }
}
