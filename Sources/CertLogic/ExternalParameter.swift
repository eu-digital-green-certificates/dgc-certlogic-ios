//
//  ExternalParameter.swift
//  
//
//  Created by Alexandr Chernyy on 08.06.2021.
//

import Foundation

// MARK: ExternalParameter type

public struct ExternalParameter: Codable {
  
  public let validationClock: Date
  public let valueSets: Dictionary<String, [String]>
  public let issuerCountryCode: String
  public let exp: Date
  public let iat: Date
  public var kid: String?

  enum CodingKeys: String, CodingKey {
    case validationClock, valueSets, issuerCountryCode, exp, iat, kid
  }
  
  public init(validationClock: Date,
       valueSets: Dictionary<String, [String]>,
       exp: Date,
       iat: Date,
       issuerCountryCode: String,
       kid: String? = nil) {
    self.validationClock = validationClock
    self.valueSets = valueSets
    self.exp = exp
    self.iat = iat
    self.issuerCountryCode = issuerCountryCode
    self.kid = kid
  }
  
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        validationClock = try container.decode(Date.self, forKey: .validationClock)
        valueSets = try container.decode(Dictionary<String, [String]>.self, forKey: .valueSets)
        exp = try container.decode(Date.self, forKey: .exp)
        iat = try container.decode(Date.self, forKey: .iat)
        issuerCountryCode = try container.decode(String.self, forKey: .issuerCountryCode)
        kid = try? container.decode(String.self, forKey: .kid)
    }
}
