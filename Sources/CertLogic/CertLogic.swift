//
//  CertLogicEngine.swift
//
//
//  Created by Alexandr Chernyy on 08.06.2021.
//
import jsonlogic
import SwiftyJSON
import Foundation

public typealias CompletionHandler = (_ resutls: [ValidationResult]) -> Void
public typealias Codable = Decodable & Encodable

final public class CertLogicEngine {
  
  private var schema: JSON?
  private var rules: [Rule]
  
  public init(schema: String, rules: [Rule]) {
    self.schema = JSON(parseJSON: schema)
    self.rules = rules
  }

  public init(schema: String, rulesData: Data) {
    self.schema = JSON(parseJSON: schema)
    self.rules = CertLogicEngine.getItems(from: rulesData)
  }

  public init(schema: String, rulesJSONString: String) {
    self.schema = JSON(parseJSON: schema)
    self.rules = CertLogicEngine.getItems(from: rulesJSONString)
  }

  public func updateRules(rules: [Rule]) {
    self.rules = rules
  }
  
  public func validate(external: ExternalParameter, payload: String) -> [ValidationResult] {
    let payloadJSON = JSON(parseJSON: payload)
    var result: [ValidationResult] = []
    guard let qrCodeCountryCode = payloadJSON["v"][0]["co"].rawValue as? String else {
      result.append(ValidationResult(rule: nil, result: .fail, validationErrors: nil))
      return result
    }

    let rulesItems = getListOfRulesFor(external: external, issuerCountryCode: qrCodeCountryCode)
    if(rules.count == 0) {
      result.append(ValidationResult(rule: nil, result: .passed, validationErrors: nil))
      return result
    }
    guard let qrCodeSchemeVersion = payloadJSON["ver"].rawValue as? String else {
      result.append(ValidationResult(rule: nil, result: .fail, validationErrors: nil))
      return result
    }
    rulesItems.forEach { rule in
      if !checkSchemeVersion(for: rule, qrCodeSchemeVersion: qrCodeSchemeVersion) {
        result.append(ValidationResult(rule: rule, result: .open, validationErrors: nil))
      } else {
        do {
          let jsonlogic = try JsonLogic(rule.logic.description)
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
  private func checkSchemeVersion(for rule: Rule, qrCodeSchemeVersion: String) -> Bool {
    //Check if major version more 1 skip this rule
    guard abs(self.getVersion(from: qrCodeSchemeVersion) - self.getVersion(from: rule.schemaVersion)) < Constants.majorVersionForSkip else {
      return false
    }
    //Check if QR code version great or equal of rule code, if no skiped this rule
    // Scheme version of QR code always should be greate of equal of rule scheme version
    guard self.getVersion(from: qrCodeSchemeVersion) >= self.getVersion(from: rule.schemaVersion) else {
      return false
    }
    return true
  }
  
  // MARK: calculate scheme version in Int "1.0.0" -> 100, "1.2.0" -> 120, 2.0.0 -> 200
  private func getVersion(from schemeString: String) -> Int {
    let codeVersionItems = schemeString.components(separatedBy: ".")
    var version: Int = 0
    let maxIndex = codeVersionItems.count - 1
    for index in 0...maxIndex {
      let division = Int(pow(Double(10), Double(Constants.maxVersion - index)))
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
    result = "{" + "{" + "\"\(Constants.external)\":" + "\(externalJsonString)" + "}," + "\"\(Constants.payload)\":" + "\(payload)" + "}" + "}"
    return result
  }
  
  // Get List of Rules for Country by Code
  private func getListOfRulesFor(external: ExternalParameter, issuerCountryCode: String) -> [Rule] {
    return rules.filter { rule in
      return rule.countryCode.lowercased() == external.countryCode.lowercased() && rule.ruleType == .acceptence || rule.countryCode.lowercased() == issuerCountryCode.lowercased() && rule.ruleType == .invalidation && rule.certificateFullType == external.certificationType || rule.certificateFullType == .general && external.validationClock >= rule.validFromDate && external.validationClock <= rule.validToDate
    }
  }

  static public func getItems<T:Decodable>(from jsonString: String) -> [T] {
    guard let jsonData = jsonString.data(using: .utf8) else { return []}
    return getItems(from: jsonData)
  }
  static public func getItems<T:Decodable>(from jsonData: Data) -> [T] {
    guard let items: [T] = try? defaultDecoder.decode([T].self, from: jsonData) else { return [] }
    return items
  }

  static public func getItem<T:Decodable>(from jsonString: String) -> T? {
    guard let jsonData = jsonString.data(using: .utf8) else { return nil}
    return getItem(from: jsonData)
  }
  static public func getItem<T:Decodable>(from jsonData: Data) -> T? {
    guard let item: T = try? defaultDecoder.decode(T.self, from: jsonData) else { return nil }
    return item
  }
  
  // Get details rule error by affected fields
  public func getDetailsOfError(rule: Rule, external: ExternalParameter) -> String {
    var value: String = ""
    rule.affectedString.forEach { key in
      var section = "test_entry"
      if external.certificationType == .recovery {
        section = "recovery_entry"
      }
      if external.certificationType == .vacctination {
        section = "vaccination_entry"
      }
      if external.certificationType == .test {
        section = "test_entry"
      }
      if let newValue = schema?["$defs"][section]["properties"][key]["description"].string {
        if value.count == 0 {
          value = value + "\(newValue)"
        } else {
          value = value + " / " + "\(newValue)"
        }
      }
    }
    return value
  }
}

extension CertLogicEngine {
  enum Constants {
    static let payload = "payload"
    static let external = "external"
    static let defSchemeVersion = "1.0.0"
    static let maxVersion: Int = 2
    static let majorVersionForSkip: Int = 100
  }
}
