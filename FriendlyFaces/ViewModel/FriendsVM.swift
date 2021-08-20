//
//  FriendsVM.swift
//  FriendlyFaces
//
//  Created by Atin Agnihotri on 19/08/21.
//

import Foundation

class FriendsVM: ObservableObject {
    @Published var users = [User]()
    
    init() {
        if users.isEmpty {
            loadPeopleFromDB()
        }
    }
    
    func loadPeopleFromDB() {
        // Can force unwrap it as this is a known url
        let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
        let request = URLRequest(url: url)
        // data, response, error
        print("reach1")
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                self?.showError(error)
                print("reach2")
                return
            }
            
            if let data = data {
                print("reach3")
                print(data)
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode([User].self, from: data) {
                    print("reach4")
                    self?.users += decodedData
                }
            }
        }.resume()
    }
    
    func showError(_ error: Error?) {
        // todo
    }
    
    func deleteFriends(at offsets: IndexSet) {
        offsets.forEach { index in
            users.remove(at: index)
        }
    }
    
    func getUser(with id: UUID) -> User?{
        users.first(where: { $0.id == id})
    }
    
    func getFriendlyUsers(for friends: [Friend]) -> [User] {
        var friendUsers = [User]()
        for friend in friends {
            if let friendUser = users.first(where: { $0.id == friend.id } ) {
                friendUsers.append(friendUser)
            }
        }
        return friendUsers
    }
}
