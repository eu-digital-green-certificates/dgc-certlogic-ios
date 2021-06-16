//
//  Rule.swift
//  
//
//  Created by Alexandr Chernyy on 08.06.2021.
//

import Foundation
import JSON
import AnyCodable

// MARK: Rule type

class Rule: Codable {
  
  var identifier: String
  var type: String
  var version: String
  var schemaVersion: String
  var engineVersion: String
  var certificateType: String
  var description: [Description]
  var validFrom: String
  var validTo: String
  var affectedString: [String]
  var logic: [String: Any]
  var countryCode: String
    
  enum CodingKeys: String, CodingKey {
    case identifier = "Identifier", type = "Type", version = "Version", schemaVersion = "SchemaVersion", engineVersion = "EngineVersion", certificateType = "CertificateType", description = "Description", validFrom = "ValidFrom", validTo = "ValidTo", affectedString = "AffectedFields", countryCode = "CountryCode", logic = "Logic"
  }
  
  // Init with custom fields
  init(identifier: String,
       type: String,
       version: String,
       schemaVersion: String,
       engineVersion: String,
       certificateType: String,
       description: [Description],
       validFrom: String,
       validTo: String,
       affectedString: [String],
       logic: [String: Any],
       countryCode: String) {
    self.identifier = identifier
    self.type = type
    self.version = version
    self.schemaVersion = schemaVersion
    self.engineVersion = engineVersion
    self.certificateType = certificateType
    self.description = description
    self.validFrom = validFrom
    self.validTo = validTo
    self.affectedString = affectedString
    self.logic = logic
    self.countryCode = countryCode
  }
  
  // Init Rule from JSON Data
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    identifier = try container.decode(String.self, forKey: .identifier)
    type = try container.decode(String.self, forKey: .type)
    version = try container.decode(String.self, forKey: .version)
    schemaVersion = try container.decode(String.self, forKey: .schemaVersion)
    engineVersion = try container.decode(String.self, forKey: .engineVersion)
    certificateType = try container.decode(String.self, forKey: .certificateType)
    description = try container.decode([Description].self, forKey: .description)
    validFrom = try container.decode(String.self, forKey: .validFrom)
    validTo = try container.decode(String.self, forKey: .validTo)
    affectedString = try container.decode([String].self, forKey: .affectedString)
    logic = try container.decode([String: Any].self, forKey: .logic)
    countryCode = try container.decode(String.self, forKey: .countryCode)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(identifier, forKey: .identifier)
    try container.encode(type, forKey: .type)
    try container.encode(version, forKey: .version)
    try container.encode(schemaVersion, forKey: .schemaVersion)
    try container.encode(engineVersion, forKey: .engineVersion)
    try container.encode(certificateType, forKey: .certificateType)
    try container.encode(description, forKey: .description)
    try container.encode(validFrom, forKey: .validFrom)
    try container.encode(validTo, forKey: .validTo)
    try container.encode(affectedString, forKey: .affectedString)
    try container.encode(affectedString, forKey: .affectedString)
  }
  
}

