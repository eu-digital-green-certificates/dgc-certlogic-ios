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
  
  private var schema: String = Constants.defSchemeVersion
  private var rules: [Rule]
  
  init(rules: [Rule]) {
    self.rules = rules
  }

  init(rulesData: Data) {
    self.rules = CertLogicEngine.getRules(from: rulesData)
  }

  init(rulesJSONString: String) {
    self.rules = CertLogicEngine.getRules(from: rulesJSONString)
  }

  func validate(schema: String, external: ExternalParameter, payload: String, completion: CompletionHandler? ) {
    self.schema = schema
    completion?([])
  }

  func validate(schema: String, external: ExternalParameter, payload: String) -> [ValidationResult] {
    self.schema = schema
    var result: [ValidationResult] = []
    let rulesItems = getListOfRulesFor(countryCode: external.countryCode)
    if(rules.count == 0) {
      result.append(ValidationResult(rule: nil, result: .passed, validationErrors: nil))
      return result
    }
    rulesItems.forEach { rule in
      if !checkSchemeVersion(for: rule) {
        result.append(ValidationResult(rule: rule, result: .open, validationErrors: nil))
      } else {
        do {
          let jsonlogic = try JsonLogic(rule.logic, customOperators: customRules)
          let results: Any = try jsonlogic.applyRule(to: getJSONStringForValidation(external: external, payload: payload))
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
    }
      return result
  }

  // MARK: check scheme version from qr code and from rule
  private func checkSchemeVersion(for rule: Rule) -> Bool {
    if self.getVersion(from: self.schema) >= self.getVersion(from: rule.schemaVersion) {
      return true
    }
    return false
  }
  
  // MARK: calculate scheme version in Int "1.0.0" -> 100, "1.2.0" -> 120, 2.0.0 -> 200
  private func getVersion(from schemeString: String) -> Int {
    let codeVersionItems = schema.components(separatedBy: ".")
    var version: Int = 0
    let maxIndex = codeVersionItems.count - 1
    for index in 0...maxIndex {
      let division = Int(pow(Double(10), Double(maxIndex - index)))
      let calcVersion: Int = Int(codeVersionItems[index]) ?? 1
      let forSum: Int =  calcVersion * division
      version = version + forSum
    }
    return version
  }
  
  // MARK:
  private func getJSONStringForValidation(external: ExternalParameter, payload: String) -> String {
    guard let jsonData = try? defaultEncoder.encode(external) else { return ""}
    let externalJsonString = String(data: jsonData, encoding: .utf8)!
    
    var result = ""
    result = "{" + "{" + "\"\(Constants.external)\":" + "\(externalJsonString)" +  "}," + "\"\(Constants.hCert)\":" + "\(payload)" + "}" + "}"
    return result
  }
  
  // Get List of Rules for Country by Code
  private func getListOfRulesFor(countryCode: String) -> [Rule] {
    return rules.filter { rule in
      return rule.countryCode.lowercased() == countryCode.lowercased()
    }
  }

  // Parce Rules from Data or JSON String
  static func getRules(from jsonString: String) -> [Rule] {
    guard let jsonData = jsonString.data(using: .utf8) else { return []}
    return getRules(from: jsonData)
  }

  static func getRules(from jsonData: Data) -> [Rule] {
    guard let rules: [Rule] = try? defaultDecoder.decode([Rule].self, from: jsonData) else { return [] }
    return rules
  }

  static func getRule(from jsonString: String) -> Rule? {
    guard let jsonData = jsonString.data(using: .utf8) else { return nil}
    return getRule(from: jsonData)
  }

  static func getRule(from jsonData: Data) -> Rule? {
    guard let rule: Rule = try? defaultDecoder.decode(Rule.self, from: jsonData) else { return nil }
    return rule
  }

  // Parce external parameters
  static func getExternalParameter(from jsonString: String) -> ExternalParameter? {
    guard let jsonData = jsonString.data(using: .utf8) else { return nil}
    return getExternalParameter(from: jsonData)
  }

  static func getExternalParameter(from jsonData: Data) -> ExternalParameter? {
    guard let externalParameter: ExternalParameter = try? defaultDecoder.decode(ExternalParameter.self, from: jsonData) else { return nil }
    return externalParameter
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

extension CertLogicEngine {
  enum Constants {
    static let hCert = "hcert"
    static let external = "external"
    static let defSchemeVersion = "1.0.0"
  }
}
