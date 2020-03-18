//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.file` struct is generated, and contains static references to 2 files.
  struct file {
    /// Resource file `Podfile`.
    static let podfile = Rswift.FileResource(bundle: R.hostingBundle, name: "Podfile", pathExtension: "")
    /// Resource file `dummyhome.png`.
    static let dummyhomePng = Rswift.FileResource(bundle: R.hostingBundle, name: "dummyhome", pathExtension: "png")
    
    /// `bundle.url(forResource: "Podfile", withExtension: "")`
    static func podfile(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.podfile
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "dummyhome", withExtension: "png")`
    static func dummyhomePng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.dummyhomePng
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 10 images.
  struct image {
    /// Image `arrow-right`.
    static let arrowRight = Rswift.ImageResource(bundle: R.hostingBundle, name: "arrow-right")
    /// Image `billingTab`.
    static let billingTab = Rswift.ImageResource(bundle: R.hostingBundle, name: "billingTab")
    /// Image `close`.
    static let close = Rswift.ImageResource(bundle: R.hostingBundle, name: "close")
    /// Image `dummyhome`.
    static let dummyhome = Rswift.ImageResource(bundle: R.hostingBundle, name: "dummyhome")
    /// Image `envelope`.
    static let envelope = Rswift.ImageResource(bundle: R.hostingBundle, name: "envelope")
    /// Image `homeTab`.
    static let homeTab = Rswift.ImageResource(bundle: R.hostingBundle, name: "homeTab")
    /// Image `selectedCheckBox`.
    static let selectedCheckBox = Rswift.ImageResource(bundle: R.hostingBundle, name: "selectedCheckBox")
    /// Image `settings`.
    static let settings = Rswift.ImageResource(bundle: R.hostingBundle, name: "settings")
    /// Image `unselectedCheckBox`.
    static let unselectedCheckBox = Rswift.ImageResource(bundle: R.hostingBundle, name: "unselectedCheckBox")
    /// Image `walletTab`.
    static let walletTab = Rswift.ImageResource(bundle: R.hostingBundle, name: "walletTab")
    
    /// `UIImage(named: "arrow-right", bundle: ..., traitCollection: ...)`
    static func arrowRight(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.arrowRight, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "billingTab", bundle: ..., traitCollection: ...)`
    static func billingTab(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.billingTab, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "close", bundle: ..., traitCollection: ...)`
    static func close(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.close, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "dummyhome", bundle: ..., traitCollection: ...)`
    static func dummyhome(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.dummyhome, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "envelope", bundle: ..., traitCollection: ...)`
    static func envelope(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.envelope, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "homeTab", bundle: ..., traitCollection: ...)`
    static func homeTab(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.homeTab, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "selectedCheckBox", bundle: ..., traitCollection: ...)`
    static func selectedCheckBox(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.selectedCheckBox, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "settings", bundle: ..., traitCollection: ...)`
    static func settings(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.settings, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "unselectedCheckBox", bundle: ..., traitCollection: ...)`
    static func unselectedCheckBox(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.unselectedCheckBox, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "walletTab", bundle: ..., traitCollection: ...)`
    static func walletTab(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.walletTab, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 6 storyboards.
  struct storyboard {
    /// Storyboard `Billing Data`.
    static let billingData = _R.storyboard.billingData()
    /// Storyboard `Home`.
    static let home = _R.storyboard.home()
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Login`.
    static let login = _R.storyboard.login()
    /// Storyboard `Settings`.
    static let settings = _R.storyboard.settings()
    /// Storyboard `Wallet`.
    static let wallet = _R.storyboard.wallet()
    
    /// `UIStoryboard(name: "Billing Data", bundle: ...)`
    static func billingData(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.billingData)
    }
    
    /// `UIStoryboard(name: "Home", bundle: ...)`
    static func home(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.home)
    }
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "Login", bundle: ...)`
    static func login(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.login)
    }
    
    /// `UIStoryboard(name: "Settings", bundle: ...)`
    static func settings(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.settings)
    }
    
    /// `UIStoryboard(name: "Wallet", bundle: ...)`
    static func wallet(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.wallet)
    }
    
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try billingData.validate()
      try home.validate()
      try launchScreen.validate()
      try login.validate()
      try settings.validate()
      try wallet.validate()
    }
    
    struct billingData: Rswift.StoryboardResourceType, Rswift.Validatable {
      let billingDataViewController = StoryboardViewControllerResource<BillingDataViewController>(identifier: "BillingDataViewController")
      let bundle = R.hostingBundle
      let name = "Billing Data"
      
      func billingDataViewController(_: Void = ()) -> BillingDataViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: billingDataViewController)
      }
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.billingData().billingDataViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'billingDataViewController' could not be loaded from storyboard 'Billing Data' as 'BillingDataViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct home: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let homeViewController = StoryboardViewControllerResource<HomeViewController>(identifier: "HomeViewController")
      let name = "Home"
      
      func homeViewController(_: Void = ()) -> HomeViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: homeViewController)
      }
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.home().homeViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'homeViewController' could not be loaded from storyboard 'Home' as 'HomeViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    struct login: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = LoginViewController
      
      let bundle = R.hostingBundle
      let loginViewController = StoryboardViewControllerResource<LoginViewController>(identifier: "LoginViewController")
      let name = "Login"
      let signupViewController = StoryboardViewControllerResource<SignupViewController>(identifier: "SignupViewController")
      
      func loginViewController(_: Void = ()) -> LoginViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: loginViewController)
      }
      
      func signupViewController(_: Void = ()) -> SignupViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: signupViewController)
      }
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.login().loginViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'loginViewController' could not be loaded from storyboard 'Login' as 'LoginViewController'.") }
        if _R.storyboard.login().signupViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'signupViewController' could not be loaded from storyboard 'Login' as 'SignupViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct settings: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "Settings"
      let settingsViewController = StoryboardViewControllerResource<SettingsViewController>(identifier: "SettingsViewController")
      
      func settingsViewController(_: Void = ()) -> SettingsViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: settingsViewController)
      }
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.settings().settingsViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'settingsViewController' could not be loaded from storyboard 'Settings' as 'SettingsViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct wallet: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "Wallet"
      let walletViewController = StoryboardViewControllerResource<WalletViewController>(identifier: "WalletViewController")
      
      func walletViewController(_: Void = ()) -> WalletViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: walletViewController)
      }
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.wallet().walletViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'walletViewController' could not be loaded from storyboard 'Wallet' as 'WalletViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
