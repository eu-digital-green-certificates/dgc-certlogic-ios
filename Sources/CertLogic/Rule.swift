//
//  Rule.swift
//  
//
//  Created by Alexandr Chernyy on 08.06.2021.
//

import Foundation
import SwiftyJSON

// MARK: Rule type

public enum RuleType: String {
  case acceptence = "Acceptance"
  case invalidation = "Invalidation"
}

public enum CertificateType: String {
  case general = "General"
  case vacctination = "Vaccination"
  case recovery = "Recovery"
  case test = "Test"
}


public class Rule: Codable {
  
  public var identifier: String
  public var type: String
  public var version: String
  public var schemaVersion: String
  public var engine: String
  public var engineVersion: String
  public var certificateType: String
  public var description: [Description]
  public var validFrom: String
  public var validTo: String
  public var affectedString: [String]
  public var logic: JSON
  public var countryCode: String
  public var region: String?
  public var hash: String?
  
  public var ruleType: RuleType {
    get { return RuleType.init(rawValue: type) ?? .acceptence }
  }
  
  public var certificateFullType: CertificateType {
    get {  return CertificateType.init(rawValue: certificateType) ?? .general }
  }
    
  public var validFromDate: Date {
    get { return Date.backendFormatter.date(from: validFrom) ?? Date() }
  }
 
  public var validToDate: Date {
    get { return Date.backendFormatter.date(from: validTo) ?? Date() }
  }
  
  public var versionInt: Int {
    get {
      let codeVersionItems = version.components(separatedBy: ".")
      var version: Int = 0
      let maxIndex = codeVersionItems.count - 1
      for index in 0...maxIndex {
        let division = Int(pow(Double(10), Double(2 - index)))
        let calcVersion: Int = Int(codeVersionItems[index]) ?? 1
        let forSum: Int =  calcVersion * division
        version = version + forSum
      }
      return version
    }
  }
  
  enum CodingKeys: String, CodingKey {
    case identifier = "Identifier", type = "Type", version = "Version", schemaVersion = "SchemaVersion", engine = "Engine", engineVersion = "EngineVersion", certificateType = "CertificateType", description = "Description", validFrom = "ValidFrom", validTo = "ValidTo", affectedString = "AffectedFields", countryCode = "Country", logic = "Logic"
  }
  
  // Set Hash of JSON string
  public func setHash(hash: String) {
    self.hash = hash
  }
 
  // Init with custom fields
  public init(identifier: String,
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
       logic: JSON,
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
  
  // Init Rule from JSON Data
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    identifier = try container.decode(String.self, forKey: .identifier)
    type = try container.decode(String.self, forKey: .type)
    version = try container.decode(String.self, forKey: .version)
    schemaVersion = try container.decode(String.self, forKey: .schemaVersion)
    engine = try container.decode(String.self, forKey: .engine)
    engineVersion = try container.decode(String.self, forKey: .engineVersion)
    certificateType = try container.decode(String.self, forKey: .certificateType)
    description = try container.decode([Description].self, forKey: .description)
    validFrom = try container.decode(String.self, forKey: .validFrom)
    validTo = try container.decode(String.self, forKey: .validTo)
    affectedString = try container.decode([String].self, forKey: .affectedString)
    logic = try container.decode(JSON.self, forKey: .logic)
    countryCode = try container.decode(String.self, forKey: .countryCode)
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(identifier, forKey: .identifier)
    try container.encode(type, forKey: .type)
    try container.encode(version, forKey: .version)
    try container.encode(schemaVersion, forKey: .schemaVersion)
    try container.encode(engine, forKey: .engine)
    try container.encode(engineVersion, forKey: .engineVersion)
    try container.encode(certificateType, forKey: .certificateType)
    try container.encode(description, forKey: .description)
    try container.encode(validFrom, forKey: .validFrom)
    try container.encode(validTo, forKey: .validTo)
    try container.encode(affectedString, forKey: .affectedString)
    try container.encode(affectedString, forKey: .affectedString)
  }
  
}

public class RuleHash: Codable {
  
  public var identifier: String
  public var version: String
  public var country: String
  public var hash: String
  
  enum CodingKeys: String, CodingKey {
    case identifier, version, country, hash
  }
  
  // Init with custom fields
  public init(identifier: String,
       type: String,
       version: String,
       country: String,
       hash: String) {
    self.identifier = identifier
    self.version = version
    self.country = country
    self.hash = hash
  }
  
  // Init Rule from JSON Data
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    identifier = try container.decode(String.self, forKey: .identifier)
    version = try container.decode(String.self, forKey: .version)
    country = try container.decode(String.self, forKey: .country)
    hash = try container.decode(String.self, forKey: .hash)
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(identifier, forKey: .identifier)
    try container.encode(version, forKey: .version)
    try container.encode(country, forKey: .country)
    try container.encode(hash, forKey: .hash)
  }
  
}


