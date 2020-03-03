//
//  User.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/29/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

struct User: Codable {
  var name: String?
  var firstName: String?
  var lastName: String?
  var username: String?
  var title: String?
  var ownTitle: String?
  var gender:String?
  var password: String?
  var emails: [ String ]?
  var phones: [ String ]?
  var address: String?
  var birthday: String?
  var enabled: String?
  var testAccount: Bool?
  var deleted: Bool?
  var currency: String?
}

