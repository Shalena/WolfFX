//
//  LegalInformation.swift
//  WolfFX
//
//  Created by Елена Острожинская on 7/7/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

let locale = Locale.current.identifier
let aboutUsUrlString = "https://cuboid-files.oss-cn-hongkong.aliyuncs.com/About%20us%20-%20\(locale).pdf"
let clientAgreementUrlString = "https://cuboid-files.oss-cn-hongkong.aliyuncs.com/Client%20agreement%20-%20\(locale).pdf"
// when you tap on terms and conditions at web the privacy policy opens
let termsAndConditionsUrlString = "https://cuboid-files.oss-cn-hongkong.aliyuncs.com/Privacy%20policy%20-%20\(locale).pdf"
let tradeCopyingTermsAndConditionsUrlString = "https://cuboid-files.oss-cn-hongkong.aliyuncs.com/Trade%20copying%20terms%20and%20conditions%20-%20\(locale).pdf"
let bestExecutionPolicyUrlString = "https://cuboid-files.oss-cn-hongkong.aliyuncs.com/Best%20execution%20policy%20-%20\(locale).pdf"
let privacyPolicyUrlString = "https://cuboid-files.oss-cn-hongkong.aliyuncs.com/Privacy%20policy%20-%20\(locale).pdf"
let riskDisclosureNoticeUrlString = "https://cuboid-files.oss-cn-hongkong.aliyuncs.com/Risk%20warning%20-%20e\(locale).pdf"


enum LegalInformation {
    case aboutUs
    case clientAgreement
    case termsAndConditions
    case tradeCopyingTermsAndConditions
    case bestExecutionPolicy
    case privacyPolicy
    case riskDisclosureNotice
    
    var title: String? {
        switch self {
        case .aboutUs:
            return R.string.localizable.aboutUs().localized()
        case .clientAgreement:
            return R.string.localizable.clientAgreement().localized()
        case .termsAndConditions:
            return R.string.localizable.termsAndConditions().localized()
        case .tradeCopyingTermsAndConditions:
            return R.string.localizable.tradeCopyingTermsAndConditions().localized()
        case .bestExecutionPolicy:
            return R.string.localizable.bestExecutionPolicy().localized()
        case .privacyPolicy:
            return R.string.localizable.clientAgreement().localized()
        case .riskDisclosureNotice:
                 return R.string.localizable.clientAgreement().localized()
       
        }
    }
    
    var link: String? {
        
        switch self {
        case .aboutUs:
            return aboutUsUrlString
        case .clientAgreement:
            return clientAgreementUrlString
        case .termsAndConditions:
            return termsAndConditionsUrlString
        case .tradeCopyingTermsAndConditions:
            return tradeCopyingTermsAndConditionsUrlString
        case .bestExecutionPolicy:
            return bestExecutionPolicyUrlString
        case .privacyPolicy:
            return privacyPolicyUrlString
        case .riskDisclosureNotice:
            return riskDisclosureNoticeUrlString
        }
    }
    
    static let all: [LegalInformation] = [.aboutUs, .clientAgreement, .tradeCopyingTermsAndConditions, .bestExecutionPolicy, .privacyPolicy, .riskDisclosureNotice]
}

