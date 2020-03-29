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
  
  /// This `R.file` struct is generated, and contains static references to 1 files.
  struct file {
    /// Resource file `Podfile`.
    static let podfile = Rswift.FileResource(bundle: R.hostingBundle, name: "Podfile", pathExtension: "")
    
    /// `bundle.url(forResource: "Podfile", withExtension: "")`
    static func podfile(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.podfile
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 13 images.
  struct image {
    /// Image `arrow left`.
    static let arrowLeft = Rswift.ImageResource(bundle: R.hostingBundle, name: "arrow left")
    /// Image `arrow-right`.
    static let arrowRight = Rswift.ImageResource(bundle: R.hostingBundle, name: "arrow-right")
    /// Image `billingTab`.
    static let billingTab = Rswift.ImageResource(bundle: R.hostingBundle, name: "billingTab")
    /// Image `close`.
    static let close = Rswift.ImageResource(bundle: R.hostingBundle, name: "close")
    /// Image `dummyHome`.
    static let dummyHome = Rswift.ImageResource(bundle: R.hostingBundle, name: "dummyHome")
    /// Image `envelope`.
    static let envelope = Rswift.ImageResource(bundle: R.hostingBundle, name: "envelope")
    /// Image `homeTab`.
    static let homeTab = Rswift.ImageResource(bundle: R.hostingBundle, name: "homeTab")
    /// Image `left-right`.
    static let leftRight = Rswift.ImageResource(bundle: R.hostingBundle, name: "left-right")
    /// Image `selectedCheckBox`.
    static let selectedCheckBox = Rswift.ImageResource(bundle: R.hostingBundle, name: "selectedCheckBox")
    /// Image `settings`.
    static let settings = Rswift.ImageResource(bundle: R.hostingBundle, name: "settings")
    /// Image `speedometer`.
    static let speedometer = Rswift.ImageResource(bundle: R.hostingBundle, name: "speedometer")
    /// Image `unselectedCheckBox`.
    static let unselectedCheckBox = Rswift.ImageResource(bundle: R.hostingBundle, name: "unselectedCheckBox")
    /// Image `walletTab`.
    static let walletTab = Rswift.ImageResource(bundle: R.hostingBundle, name: "walletTab")
    
    /// `UIImage(named: "arrow left", bundle: ..., traitCollection: ...)`
    static func arrowLeft(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.arrowLeft, compatibleWith: traitCollection)
    }
    
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
    
    /// `UIImage(named: "dummyHome", bundle: ..., traitCollection: ...)`
    static func dummyHome(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.dummyHome, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "envelope", bundle: ..., traitCollection: ...)`
    static func envelope(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.envelope, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "homeTab", bundle: ..., traitCollection: ...)`
    static func homeTab(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.homeTab, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "left-right", bundle: ..., traitCollection: ...)`
    static func leftRight(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.leftRight, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "selectedCheckBox", bundle: ..., traitCollection: ...)`
    static func selectedCheckBox(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.selectedCheckBox, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "settings", bundle: ..., traitCollection: ...)`
    static func settings(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.settings, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "speedometer", bundle: ..., traitCollection: ...)`
    static func speedometer(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.speedometer, compatibleWith: traitCollection)
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
  
  /// This `R.nib` struct is generated, and contains static references to 1 nibs.
  struct nib {
    /// Nib `BaseHeaderView`.
    static let baseHeaderView = _R.nib._BaseHeaderView()
    
    /// `UINib(name: "BaseHeaderView", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.baseHeaderView) instead")
    static func baseHeaderView(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.baseHeaderView)
    }
    
    static func baseHeaderView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
      return R.nib.baseHeaderView.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
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
    try nib.validate()
  }
  
  struct nib: Rswift.Validatable {
    static func validate() throws {
      try _BaseHeaderView.validate()
    }
    
    struct _BaseHeaderView: Rswift.NibResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "BaseHeaderView"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "envelope", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'envelope' is used in nib 'BaseHeaderView', but couldn't be loaded.") }
        if UIKit.UIImage(named: "speedometer", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'speedometer' is used in nib 'BaseHeaderView', but couldn't be loaded.") }
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
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
        if UIKit.UIImage(named: "dummyHome", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'dummyHome' is used in storyboard 'Home', but couldn't be loaded.") }
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
      let profileDetailsViewController = StoryboardViewControllerResource<ProfileDetailsViewController>(identifier: "ProfileDetailsViewController")
      let settingsViewController = StoryboardViewControllerResource<SettingsViewController>(identifier: "SettingsViewController")
      
      func profileDetailsViewController(_: Void = ()) -> ProfileDetailsViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: profileDetailsViewController)
      }
      
      func settingsViewController(_: Void = ()) -> SettingsViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: settingsViewController)
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "arrow-right", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'arrow-right' is used in storyboard 'Settings', but couldn't be loaded.") }
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.settings().profileDetailsViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'profileDetailsViewController' could not be loaded from storyboard 'Settings' as 'ProfileDetailsViewController'.") }
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
