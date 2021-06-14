//
//  File.swift
//  
//
//  Created by Alexandr Chernyy on 14.06.2021.
//

import Foundation

extension Date {

    static var shortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    //2021-06-03T09:40:51Z
    static var fullFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()

    func date(byAddingDays days: Int, in calendar: Calendar = .current) -> Date {
        let result = calendar.date(byAdding: .day, value: days, to: self) ?? Date()
        return result
    }
    
    var shortFormatted: String {
        return Date.shortFormatter.string(from: self)
    }

    var fullFormatted: String {
        return Date.fullFormatter.string(from: self)
    }
}

extension String {
    var date: Date? {
        if let date = Date.shortFormatter.date(from:self) {
            return date
        }
        if let date = Date.fullFormatter.date(from:self) {
            return date
        }
        return nil
    }
}
