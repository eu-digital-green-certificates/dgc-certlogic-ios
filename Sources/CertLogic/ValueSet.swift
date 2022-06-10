//
//  File.swift
//  
//
//  Created by Alexandr Chernyy on 25.06.2021.
//

import Foundation

// MARK: ValueSets type

public struct ValueSet: Codable {
    public let valueSetId: String
    public let valueSetDate: String
    public let valueSetValues: Dictionary<String, ValueSetItem>
    public var hash: String?
    
    // Set Hash of JSON string
    public mutating func setHash(hash: String) {
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
    
    public init(from decoder: Decoder) throws {
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
    public let id: String
    public let hash: String
    
    public var identifier: String {
        return id
    }
}
