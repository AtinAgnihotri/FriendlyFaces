//
//  FriendsVM.swift
//  FriendlyFaces
//
//  Created by Atin Agnihotri on 19/08/21.
//

import Foundation

class FriendsVM: ObservableObject {
    @Published var users = [User]()
    let coreDataManager = CoreDataManager.shared
    
    init() {
        if users.isEmpty {
            if !areUsersInLocal() {
                print("No Users in local storage. Loading over network")
                loadUsersOverNetwork()
            } else {
                print("Loaded Users from local storage")
            }
        }
    }
    
    func loadUsersOverNetwork() {
        // Can force unwrap it as this is a known url
        let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                self?.showError(error)
                return
            }
            
            if let data = data {
                print(data)
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode([User].self, from: data) {
                    DispatchQueue.main.async {
                        self?.users += decodedData
                        self?.saveUsersToLocal()
                    }
                }
            }
        }.resume()
    }
    
    func showError(_ error: Error?) {
        // todo
    }
    
    func deleteFriends(at offsets: IndexSet) {
        offsets.forEach { index in
            coreDataManager.deleteFromCDIfAvailable(user: users[index])
        }
        users.remove(atOffsets: offsets)
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
    
    func areUsersInLocal() -> Bool {
        let localUsers = coreDataManager.getAllUsersFromCD()
        if localUsers.isEmpty {
            return false
        } else {
            users += localUsers
            return true
        }
    }
    
    func saveUsersToLocal() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.users.forEach { user in
                self?.coreDataManager.saveToCDIfUnavailable(user: user)
            }
            print("Saved fetched users to local storage")
        }
    }
    
}
