//
//  CertLogicEngine.swift
//
//
//  Created by Alexandr Chernyy on 08.06.2021.
//
import jsonlogic
import JSON
import Foundation

typealias CompletionHandler = (_ resutls: [ValidationResult]) -> Void

final class CertLogicEngine {
  
  private var schema: String
  private var rules: [Rule]
  
  init(schema: String, rules: [Rule]) {
    self.schema = schema
    self.rules = rules
  }
  
  func validate(external: ExternalParameter, payload: String, completion: CompletionHandler? ) {
      completion?([])
  }
  
  // Get List of Rules for Country by Code
  private func getListOfRulesFor(countryCode: String) -> [Rule] {
    return rules.filter { rule in
      return rule.countryCode == countryCode
    }
  }

  
}

