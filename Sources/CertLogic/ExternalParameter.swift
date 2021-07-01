//
//  ExternalParameter.swift
//  
//
//  Created by Alexandr Chernyy on 08.06.2021.
//

import Foundation

// MARK: ExternalParameter type

public class ExternalParameter: Codable {
  
  public var validationClock: Date
  public var valueSets: Dictionary<String, [String]>
  public var countryCode: String
  public var issueCountryCode: String
  public var exp: Date
  public var iat: Date
  public var certificationType: CertificateType = .general
  public var kid: String?
  public var region: String?

  enum CodingKeys: String, CodingKey {
    case validationClock, valueSets, countryCode, exp, iat, issueCountryCode, kid, region
  }
  
  public init(validationClock: Date,
       valueSets: Dictionary<String, [String]>,
       countryCode: String,
       exp: Date,
       iat: Date,
       certificationType: CertificateType,
       issueCountryCode: String,
       region: String? = nil) {
    self.validationClock = validationClock
    self.valueSets = valueSets
    self.countryCode = countryCode
    self.exp = exp
    self.iat = iat
    self.certificationType = certificationType
    self.issueCountryCode = issueCountryCode
    self.region = region
  }
  
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    validationClock = try container.decode(Date.self, forKey: .validationClock)
    valueSets = try container.decode(Dictionary<String, [String]>.self, forKey: .valueSets)
    countryCode = try container.decode(String.self, forKey: .countryCode)
    exp = try container.decode(Date.self, forKey: .exp)
    iat = try container.decode(Date.self, forKey: .iat)
    issueCountryCode = try container.decode(String.self, forKey: .issueCountryCode)
    kid = try? container.decode(String.self, forKey: .kid)
    region = try? container.decode(String.self, forKey: .region)
  }
}
