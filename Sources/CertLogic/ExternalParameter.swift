//
//  ExternalParameter.swift
//  
//
//  Created by Alexandr Chernyy on 08.06.2021.
//

import Foundation

// MARK: ExternalParameter type

class ExternalParameter {
  
  var validationClock: Date
  var valueSets: Dictionary<String, [String]>
  var countryCode: String
  var exp: Date
  var iat: Date
  
  init(validationClock: Date,
       valueSets: Dictionary<String, [String]>,
       countryCode: String,
       exp: Date,
       iat: Date) {
    self.validationClock = validationClock
    self.valueSets = valueSets
    self.countryCode = countryCode
    self.exp = exp
    self.iat = iat
  }
}
