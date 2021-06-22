//
//  ValidationResult.swift
//
//
//  Created by Alexandr Chernyy on 08.06.2021.
//
import Foundation

// MARK: Result type

public enum Result: Int {
  case passed = 0
  case fail
  case open
}

// MARK: ValidationResult

public class ValidationResult {
  
  public var rule: Rule?
  public var result: Result = .open
  public var validationErrors: [Error]?
  
  public init(rule: Rule?,
       result: Result = .open,
       validationErrors: [Error]? = nil) {
    self.rule = rule
    self.result = result
    self.validationErrors = validationErrors
  }
}
