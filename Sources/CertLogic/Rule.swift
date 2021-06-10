//
//  Rule.swift
//  
//
//  Created by Alexandr Chernyy on 08.06.2021.
//

import Foundation

// MARK: Rule type

class Rule {
  var identifier: String
  var type: String
  var version: String
  var schemaVersion: String
  var engine: String
  var engineVersion: String
  var certificateType: String
  var description: [Description]
  var validFrom: String
  var validTo: String
  var affectedString: [String]
  var logic: String
  var countryCode: String
  
  init(identifier: String,
       type: String,
       version: String,
       schemaVersion: String,
       engine: String,
       engineVersion: String,
       certificateType: String,
       description: [Description],
       validFrom: String,
       validTo: String,
       affectedString: [String],
       logic: String,
       countryCode: String) {
    self.identifier = identifier
    self.type = type
    self.version = version
    self.schemaVersion = schemaVersion
    self.engine = engine
    self.engineVersion = engineVersion
    self.certificateType = certificateType
    self.description = description
    self.validFrom = validFrom
    self.validTo = validTo
    self.affectedString = affectedString
    self.logic = logic
    self.countryCode = countryCode
  }
}
