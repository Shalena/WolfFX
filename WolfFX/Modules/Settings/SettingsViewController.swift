//
//  SettingsViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit
import SafariServices

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
    @IBOutlet weak var legalInformationTitleView: UIView!
    @IBOutlet weak var legalInformation: UILabel!
    @IBOutlet weak var legalInfoView: UIView!
    @IBOutlet weak var legalArrow: UIImageView!
    @IBOutlet weak var supportView: UIView!
    @IBOutlet weak var supportHeaderView: UIView!
    @IBOutlet weak var suppportArrow: UIImageView!
    
    var languageViewIsHidden = true
    var supportViewIsHidden = true
    var legalInfoIsHidden = true
    
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
        let supportTap = UITapGestureRecognizer(target: self, action: #selector(self.supportTapped(_:)))
        supportHeaderView.addGestureRecognizer(supportTap)
        let legalInfoTap = UITapGestureRecognizer(target: self, action: #selector(self.legalInfoTapped(_:)))
        legalInformationTitleView.addGestureRecognizer(legalInfoTap)
    }
    
    func localize() {
         settingsTitle.text = R.string.localizable.settings().localized()
         profileData.text = R.string.localizable.profileData().localized()
         language.text = R.string.localizable.language().localized()
         support.text = R.string.localizable.support().localized()
         howToTrade.text = R.string.localizable.howToTrade().localized()
         legalInformation.text = R.string.localizable.legalInformation().localized()
         loginAndSighOutLabel.text = R.string.localizable.logIn().localized()
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
    
    @objc private func supportTapped(_ sender: UITapGestureRecognizer? = nil) {
        supportViewIsHidden = !supportViewIsHidden
        supportView.isHidden = supportViewIsHidden
        var angle = CGFloat(0.0)
        if supportViewIsHidden {
            angle = .pi / -2
        } else {
            angle = .pi / 2
        }
        suppportArrow.transform = suppportArrow.transform.rotated(by: angle)
    }
    
    @objc private func legalInfoTapped(_ sender: UITapGestureRecognizer? = nil) {
        legalInfoIsHidden = !legalInfoIsHidden
        legalInfoView.isHidden = legalInfoIsHidden
        var angle = CGFloat(0.0)
        if legalInfoIsHidden {
            angle = .pi / -2
        } else {
            angle = .pi / 2
        }
        legalArrow.transform = legalArrow.transform.rotated(by: angle)
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
        if let systemLanguageName = selectedLanguage?.systemName {
            Bundle.setLanguage(lang: systemLanguageName)
            localize()
            if let tabBar = tabBarController?.tabBar {
                TabbarConfigurator().localizeForce(tabBar: tabBar)
            }
        }
    }
}
