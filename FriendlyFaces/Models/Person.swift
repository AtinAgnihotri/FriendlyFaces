//
//  Person.swift
//  FriendlyFaces
//
//  Created by Atin Agnihotri on 19/08/21.
//

import Foundation

struct Person: Codable {
    var id: UUID
    var isActive: Bool
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: Date
    var tags: [String]
    var friends: [Friend]
}
