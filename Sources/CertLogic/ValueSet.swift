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

public struct ValueSetItem: Codable {
  
  public let display: String
  public let lang: String
  public let active: Bool
  public let system: String
  public let version: String
}

public struct ValueSetHash: Codable {
  public let identifier: String
  public let hash: String
  
  enum CodingKeys: String, CodingKey {
    case identifier = "id", hash
  }
  
  // Init with custom fields
  public init(identifier: String, type: String, hash: String) {
    self.identifier = identifier
    self.hash = hash
  }
  
  // Init Rule from JSON Data
    public init(from decoder: Decoder) throws {
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
