//
//  CoreDataManager.swift
//  FriendlyFaces
//
//  Created by Atin Agnihotri on 20/08/21.
//

import Foundation
import CoreData

class CoreDataManager {
    
    let persistentContainer: NSPersistentContainer
    static let shared = CoreDataManager()
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "FriendlyFacesDataModel")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Core Data Store Failed with error: \(error.localizedDescription)")
            }
        }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func saveToCDIfUnavailable(user: User) {
        let userToSave = getCDUser(from: user)
        if context.hasChanges {
            try? context.save()
        }
    }
    
    func getSetOfFriends(friends: [Friend]) -> NSSet {
        var set = NSSet()
        for friend in friends {
            let cdFriend = getCDFriend(from: friend)
            set = set.adding(cdFriend) as NSSet
            if context.hasChanges {
                try? context.save()
            }
        }
        return set
    }
    
    func getSetOfTags(tags: [String]) -> NSSet {
        var set = NSSet()
        for tag in tags {
            let cdTag = CDTag(context: context)
            cdTag.tag = tag
            set = set.adding(cdTag) as NSSet
            if context.hasChanges {
                try? context.save()
            }
        }
        return set
    }
    
    func deleteFromCDIfAvailable(user: User) {
        if let userToDelete = getCDUser(with: user.id) {
            if let friendToDelete = getCDUser(with: user.id) {
                context.delete(userToDelete)
                context.delete(friendToDelete)
                
                do {
                    try context.save()
                } catch {
                    context.rollback()
                }
            }
            
        }
    }
    
    func getAllUsersFromCD() -> [User] {
        var users = [User]()
        let fetchRequest: NSFetchRequest<CDUser> = CDUser.fetchRequest()
        do {
            let cdUsers = try context.fetch(fetchRequest)

            cdUsers.forEach { cdUser in
                let tags = getTags(from: cdUser.tags)
                let friends = getFriends(from: cdUser.friends)
                
                let user = User(id: cdUser.id!,
                                isActive: cdUser.isActive,
                                name: cdUser.name!,
                                age: Int(cdUser.age),
                                company: cdUser.company!,
                                email: cdUser.email!,
                                address: cdUser.address!,
                                about: cdUser.about!,
                                registered: cdUser.registered!,
                                tags: tags,
                                friends: friends)
                users.append(user)
            }
        } catch {
            print("Error fetching from Core Data")
        }
        
        return users
    }
    
    func getTags(from cdTags: NSSet?) -> [String] {
        guard let cdTags = cdTags?.sortedArray(using: []) as? [CDTag] else {
            return []
        }
        var tags = [String]()
        cdTags.forEach { cdTag in
            if let tag = cdTag.tag {
                tags.append(tag)
            }
        }
        return tags
    }
    
    func getFriends(from cdFriends: NSSet?) -> [Friend] {
        guard let cdFriends = cdFriends?.sortedArray(using: []) as? [CDFriend] else {
            return []
        }
        var friends = [Friend]()
        cdFriends.forEach { cdFriend in
            if let id = cdFriend.id {
                if let name = cdFriend.name {
                    let friend = Friend(id: id, name: name)
                    friends.append(friend)
                }
            }
        }
        return friends
    }
    
    
    func getCDUser(with id: UUID) -> CDUser? {
        let fetchRequest: NSFetchRequest<CDUser> = CDUser.fetchRequest()
        do {
            let fetch = try context.fetch(fetchRequest)
            if let cdUser = fetch.first(where: { $0.id == id}) {
                return cdUser
            }
        } catch {
            print("No user for id \(id.uuidString) found")
        }
        return nil
    }
    
    
    func getCDUser(from user: User) -> CDUser{
        let cdUser = CDUser(context: context)
        cdUser.id = user.id
        cdUser.isActive = user.isActive
        cdUser.name = user.name
        cdUser.about = user.about
        cdUser.address = user.address
        cdUser.company = user.company
        cdUser.age = Int16(user.age)
        cdUser.email = user.email
        cdUser.registered = user.registered
        
        user.friends.forEach { friend in
            if let existingFriend = getFriend(with: friend.id) {
                cdUser.addToFriends(existingFriend)
            } else {
                let cdFriend = getCDFriend(from: friend)
                cdUser.addToFriends(cdFriend)
            }
        }
        
        user.tags.forEach { tag in
            if let existingTag = getTag(with: tag) {
                cdUser.addToTags(existingTag)
            } else {
                let cdTag = CDTag(context: context)
                cdTag.tag = tag
                cdUser.addToTags(cdTag)
            }
        }
       
        return cdUser
    }
    
    func getCDFriend(from friend: Friend) -> CDFriend {
        let cdFriend = CDFriend(context: context)
        cdFriend.id = friend.id
        cdFriend.name = friend.name
        return cdFriend
    }
    
    func getCDFriends(from friends: [Friend]) -> [CDFriend] {
        var cdFriends = [CDFriend]()
        friends.forEach { friend in
            cdFriends.append(getCDFriend(from: friend))
        }
        return cdFriends
    }
    
    func getFriend(with id: UUID) -> CDFriend? {
        let fetchRequest: NSFetchRequest<CDFriend> = CDFriend.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = $id").withSubstitutionVariables(["id": id])
        do {
            let fetch = try context.fetch(fetchRequest)
            if let friend = fetch.first(where: {$0.id == id}) {
                return friend
            }
        } catch {
            print("No such friend found")
        }
        return nil
    }
    
    func getTag(with tag: String) -> CDTag? {
        let fetchRequest: NSFetchRequest<CDTag> = CDTag.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "tag", tag)
        do {
            let fetch = try context.fetch(fetchRequest)
            if let tag = fetch.first(where: {$0.tag == tag}) {
                return tag
            }
        } catch {
            print("No such friend found")
        }
        return nil
    }

}
