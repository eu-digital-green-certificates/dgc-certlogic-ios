//
//  ValidationResult.swift
//
//
//  Created by Alexandr Chernyy on 08.06.2021.
//
import Foundation

// MARK: Result type

enum Result: Int {
  case passed = 0
  case fail
  case open
}

// MARK: ValidationResult

class ValidationResult {
  
  private var rule: Rule
  private var result: Result = .open
  private var validationErrors: [Error]?
  
  init(rule: Rule,
       result: Result = .open,
       validationErrors: [Error]? = nil) {
    self.rule = rule
    self.result = result
    self.validationErrors = validationErrors
  }
}
