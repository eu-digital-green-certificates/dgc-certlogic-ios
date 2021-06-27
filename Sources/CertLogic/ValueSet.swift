//
//  File.swift
//  
//
//  Created by Alexandr Chernyy on 25.06.2021.
//

import Foundation

// MARK: ValueSets type

public class ValueSet: Codable {
  
  public var valueSetId: String
  public var valueSetDate: String
  public var valueSetValues: Dictionary<String, ValueSetItem>
  public var hash: String?
  
  // Set Hash of JSON string
  public func setHash(hash: String) {
    self.hash = hash
  }
  
  enum CodingKeys: String, CodingKey {
    case valueSetId, valueSetDate, valueSetValues
  }
  
  public init(valueSetId: String, valueSetDate: String, valueSetValues: Dictionary<String, ValueSetItem>) {
    self.valueSetId = valueSetId
    self.valueSetDate = valueSetDate
    self.valueSetValues = valueSetValues
  }
  
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    valueSetId = try container.decode(String.self, forKey: .valueSetId)
    valueSetDate = try container.decode(String.self, forKey: .valueSetDate)
    valueSetValues = try container.decode(Dictionary.self, forKey: .valueSetValues)
  }
  
}

public class ValueSetItem: Codable {
  
  public var display: String
  public var lang: String
  public var active: Bool
  public var system: String
  public var version: String
  
  enum CodingKeys: String, CodingKey {
    case display, lang, active, system, version
  }
  
  public init(display: String, lang: String, active: Bool, system: String, version: String) {
    self.display = display
    self.lang = lang
    self.active = active
    self.system = system
    self.version = version
  }
  
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    display = try container.decode(String.self, forKey: .display)
    lang = try container.decode(String.self, forKey: .lang)
    active = try container.decode(Bool.self, forKey: .active)
    system = try container.decode(String.self, forKey: .system)
    version = try container.decode(String.self, forKey: .version)
  }
}

public class ValueSetHash: Codable {
  
  public var identifier: String
  public var hash: String
  
  enum CodingKeys: String, CodingKey {
    case identifier = "id", hash
  }
  
  // Init with custom fields
  public init(identifier: String,
       type: String,
       hash: String) {
    self.identifier = identifier
    self.hash = hash
  }
  
  // Init Rule from JSON Data
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    identifier = try container.decode(String.self, forKey: .identifier)
    hash = try container.decode(String.self, forKey: .hash)
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(identifier, forKey: .identifier)
    try container.encode(hash, forKey: .hash)
  }
  
}
