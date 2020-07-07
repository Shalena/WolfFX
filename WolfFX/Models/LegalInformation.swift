//
//  LegalInformation.swift
//  WolfFX
//
//  Created by Елена Острожинская on 7/7/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

enum LegalInformation {
    case aboutUs
    case clientAgreement
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
        case .clientAgreement:
            return "https://cuboid-files.oss-cn-hongkong.aliyuncs.com/Client%20agreement%20-%20en.pdf"
        default:
            return ""
        }
    }
    
    static let all: [LegalInformation] = [.aboutUs, .clientAgreement, .tradeCopyingTermsAndConditions, .bestExecutionPolicy, .privacyPolicy, .riskDisclosureNotice]
}

