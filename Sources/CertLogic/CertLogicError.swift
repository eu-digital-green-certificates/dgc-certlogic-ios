//
//  File.swift
//  
//
//  Created by Alexandr Chernyy on 29.06.2021.
//

import Foundation

enum CertLogicError: Error {
    // Throw when an schemeversion not valid
  case openState
    // Throw in all other cases
  case unexpected(code: Int)
}

extension CertLogicError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .openState:
            return NSLocalizedString(
              "recheck_rule",
              comment: "Invalid Password"
          )
        case .unexpected(_):
            return NSLocalizedString(
              "unknown_error",
              comment: "Unexpected Error")
        }
    }
}

extension CertLogicError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .openState:
            return NSLocalizedString(
                "recheck_rule",
                comment: "Invalid Password"
            )
        case .unexpected(_):
          return NSLocalizedString(
              "unknown_error",
              comment: "Unexpected Error")
        }
    }
}
