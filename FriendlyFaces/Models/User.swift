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
        // todo write proper conversion
        Date(timeIntervalSinceReferenceDate: TimeInterval(registered) ?? TimeInterval(0))
    }
}
