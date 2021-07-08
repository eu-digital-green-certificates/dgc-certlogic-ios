//
//  File.swift
//  
//
//  Created by Alexandr Chernyy on 08.07.2021.
//

import Foundation

// MARK: ExternalParameter type

public class FilterParameter {
  
  public var validationClock: Date
  public var countryCode: String
  public var region: String?
  public var certificationType: CertificateType = .general

  public init(validationClock: Date,
       countryCode: String,
       certificationType: CertificateType,
       region: String? = nil) {
    self.validationClock = validationClock
    self.countryCode = countryCode
    self.certificationType = certificationType
    self.region = region
  }
}
