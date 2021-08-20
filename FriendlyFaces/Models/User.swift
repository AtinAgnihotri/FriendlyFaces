//
//  Person.swift
//  FriendlyFaces
//
//  Created by Atin Agnihotri on 19/08/21.
//

import Foundation

struct User: Codable {
    
    var id: UUID
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: String
    var tags: [String]
    var friends: [Friend]
    var registrationData: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:registered)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        return calendar.date(from:components) ?? Date(timeIntervalSinceNow: TimeInterval(0))
    }
    var allTags: String {
        tags.joined(separator: ", ")
    }
}
