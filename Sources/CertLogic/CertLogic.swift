//
//  CertLogicEngine.swift
//
//
//  Created by Alexandr Chernyy on 08.06.2021.
//
import jsonlogic
import JSON
import Foundation

final class CertLogicEngine {
  
  private var schema: String
  private var rules: [Rule]
  
  init(schema: String, rules: [Rule]) {
    self.schema = schema
    self.rules = rules
  }
  
  func validate(external: ExternalParameter, payload: String) -> [ValidationResult] {
    return []
  }
  
  // Get List of Rules for Country by Code
  private func getListOfRulesFor(countryCode: String) -> [Rule] {
    return rules.filter {
      
    }
  }

  
}

