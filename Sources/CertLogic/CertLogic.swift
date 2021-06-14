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

  func validate(external: ExternalParameter, payload: String) -> [ValidationResult] {
    var result: [ValidationResult] = []
    getListOfRulesFor(countryCode: "UA").forEach { rule in
      do {
        let jsonlogic = try JsonLogic(rule.logic, customOperators: customRules)
        let results: Any = try jsonlogic.applyRule(to: payload)
        if results is Bool {
          if results as! Bool {
            result.append(ValidationResult(rule: rule, result: .passed, validationErrors: nil))
          } else {
            result.append(ValidationResult(rule: rule, result: .fail, validationErrors: nil))
          }
        }
        print("result: \(result)")
      } catch {
        print("Unexpected error: \(error)")
        result.append(ValidationResult(rule: rule, result: .fail, validationErrors: [error]))
      }
    }
      return result
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
  
  // MARK: Custom Rules
  
  let customRules =
      ["plusDays": { (json: JSON?) -> JSON in
          switch json {
          case let .Array(array):
              if let date = array[0].date, let daysToAdd = array[1].int {
                  return JSON(date.date(byAddingDays: Int(daysToAdd)))
              }
              return JSON(0)
          default:
              return JSON(0)
          }
      },
      "plusTime": { (json: JSON?) -> JSON in
          switch json {
          case let .Array(array):
              if let date = array[0].date, let daysToAdd = array[1].int, let rule = array[2].string, rule == "day" {
                  return JSON(date.date(byAddingDays: Int(daysToAdd)))
              }
              return JSON(0)
          default:
              return JSON(0)
          }
      }]

}
