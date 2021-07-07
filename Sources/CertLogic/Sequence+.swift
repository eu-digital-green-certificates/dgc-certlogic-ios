//
//  File.swift
//  
//
//  Created by Alexandr Chernyy on 07.07.2021.
//

import Foundation

public extension Sequence {
    func group<Key>(by keyPath: KeyPath<Element, Key>) -> [Key: [Element]] where Key: Hashable {
        return Dictionary(grouping: self, by: {
            $0[keyPath: keyPath]
        })
    }
}
