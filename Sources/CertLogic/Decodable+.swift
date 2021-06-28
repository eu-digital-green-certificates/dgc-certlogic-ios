//
//  File.swift
//  
//
//  Created by Alexandr Chernyy on 15.06.2021.
//

import Foundation

public var defaultEncoder: JSONEncoder {
    let encoder = JSONEncoder()
    
    let formatter = Date.backendFormatter
    
    encoder.dateEncodingStrategy = .formatted(formatter)
    
    return encoder
}

public var defaultDecoder: JSONDecoder {
    let encoder = JSONDecoder()
    
    let formatter = Date.backendFormatter
    
    encoder.dateDecodingStrategy = .formatted(formatter)
    
    return encoder
}
