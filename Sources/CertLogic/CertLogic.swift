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

  init(schema: String, rulesData: Data) {
    self.schema = schema
    self.rules = CertLogicEngine.getRules(from: rulesData)
  }

  init(schema: String, rulesJSONString: String) {
    self.schema = schema
    self.rules = CertLogicEngine.getRules(from: rulesJSONString)
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

  // Parce Rules from Data or JSON String
  static func getRules(from jsonString: String) -> [Rule] {
    guard let jsonData = jsonString.data(using: .utf8) else { return []}
    return getRules(from: jsonData)
  }

  static func getRules(from jsonData: Data) -> [Rule] {
    guard let rules: [Rule] = try? JSONDecoder().decode([Rule].self, from: jsonData) else { return [] }
    return rules
  }

  static func getRule(from jsonString: String) -> Rule? {
    guard let jsonData = jsonString.data(using: .utf8) else { return nil}
    return getRule(from: jsonData)
  }

  static func getRule(from jsonData: Data) -> Rule? {
    guard let rule: Rule = try? JSONDecoder().decode(Rule.self, from: jsonData) else { return nil }
    return rule
  }

}

