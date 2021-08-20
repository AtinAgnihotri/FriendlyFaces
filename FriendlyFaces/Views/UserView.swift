//
//  UserView.swift
//  FriendlyFaces
//
//  Created by Atin Agnihotri on 20/08/21.
//

import SwiftUI

struct UserView: View {
    var user: User
    @ObservedObject var friendsVM: FriendsVM
    
    var activeStatus: String {
        "User is \(!user.isActive ? "not " : "")active"
    }
    
    init(for user: User, with friendsVM: FriendsVM) {
        self.user = user
        self.friendsVM = friendsVM
    }
    
    var activeStatusSymbol: some View {
        Circle()
            .foregroundColor(user.isActive ? Color.green : Color.red)
            .padding(0)
            .frame(width: 25, height: 25)
            
    }
    
    var friendlyUsers: [User] {
        friendsVM.getFriendlyUsers(for: user.friends)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Details")) {
                HStack {
                    Text(activeStatus)
                    Spacer()
                    activeStatusSymbol
                }
                Text("Since: \(user.registrationData)")
                Text("Age: \(user.age)")
                Text("Company: \(user.company)")
                Text("Email: \(user.email)") //address
                Text("Email: \(user.address)")
                
            }
            
            Section(header: Text("About")) {
                Text(user.about)
            }
            
            Section(header: Text("Friends")) {
                ForEach(friendlyUsers, id:\.id) { user in
                    NavigationLink(
                        destination: UserView(for: user, with: friendsVM),
                        label: {
                            UserListItemView(name: user.name, tags: user.allTags)
                        })
                }
            }
            
        }.navigationTitle(user.name)
//        ScrollView {
//            Form {
//                Text("\(user.name)")
//            }
////            VStack {
////                Text("\(user.name)")
////                Form {
////
////                    Text("\(activeStatus)")
////                }
////            }
//        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var friendsVM = FriendsVM()
    static var user = getTestUser()
    static var previews: some View {
        UserView(for: user, with: friendsVM)
    }
    
    static func getTestUser() -> User {
        User(id: UUID(uuidString: "50a48fa3-2c0f-4397-ac50-64da464f9954")!,
                            isActive: false,
                            name: "Alford Rodriguez",
                            age: 21,
                            company: "Imkan",
                            email: "alfordrodriguez@imkan.com",
                            address: "907 Nelson Street, Cotopaxi, South Dakota, 5913",
                            about: """
                                Occaecat consequat elit aliquip magna laboris dolore laboris sunt officia adipisicing reprehenderit sunt. Do in proident consectetur labore. Laboris pariatur quis incididunt nostrud labore ad cillum veniam ipsum ullamco. Dolore laborum commodo veniam nisi. Eu ullamco cillum ex nostrud fugiat eu consequat enim cupidatat. Non incididunt fugiat cupidatat reprehenderit nostrud eiusmod eu sit minim do amet qui cupidatat. Elit aliquip nisi ea veniam proident dolore exercitation irure est deserunt.\r\n
                                """,
                            registered: "2015-11-10T01:47:18-00:00",
                            tags: [
                                "cillum",
                                "consequat",
                                "deserunt",
                                "nostrud",
                                "eiusmod",
                                "minim",
                                "tempor"
                                ],
                            friends: [
                                Friend(id: UUID(uuidString: "91b5be3d-9a19-4ac2-b2ce-89cc41884ed0")!,
                                       name: "Hawkins Patel"),
                                Friend(id: UUID(uuidString: "0c395a95-57e2-4d53-b4f6-9b9e46a32cf6")!,
                                       name: "Jewel Sexton"),
                                Friend(id: UUID(uuidString: "be5918a3-8dc2-4f77-947c-7d02f69a58fe")!,
                                       name: "Berger Robertson")
                            ])
        
    }
}
