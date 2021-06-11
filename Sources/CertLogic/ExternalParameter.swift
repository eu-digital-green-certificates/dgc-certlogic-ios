//
//  ExternalParameter.swift
//  
//
//  Created by Alexandr Chernyy on 08.06.2021.
//

import Foundation

// MARK: ExternalParameter type

class ExternalParameter: Codable {
  
  var validationClock: Date
  var valueSets: Dictionary<String, [String]>
  var countryCode: String
  var exp: Date
  var iat: Date
  
  enum CodingKeys: String, CodingKey {
    case validationClock, valueSets, countryCode, exp, iat
  }
  
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
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    validationClock = try container.decode(Date.self, forKey: .validationClock)
    valueSets = try container.decode(Dictionary<String, [String]>.self, forKey: .valueSets)
    countryCode = try container.decode(String.self, forKey: .countryCode)
    exp = try container.decode(Date.self, forKey: .exp)
    iat = try container.decode(Date.self, forKey: .iat)
  }
}
