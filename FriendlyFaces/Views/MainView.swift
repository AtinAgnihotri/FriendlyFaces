//
//  ContentView.swift
//  FriendlyFaces
//
//  Created by Atin Agnihotri on 19/08/21.
//

import SwiftUI

struct UserListItemView: View {
    @State var name: String
    @State var tags: String
    
    var body: some View {
        VStack {
            HStack {
                Text(name)
                    .font(.headline)
                Spacer()
            }
            HStack {
                Text(tags)
                    .lineLimit(1)
                    .font(.subheadline)
                Spacer()
            }
        }
    }
}

struct MainView: View {
    
    @ObservedObject var friendsVM = FriendsVM()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(friendsVM.users, id: \.id) { user in
                    NavigationLink(destination: UserView(for: user, with: friendsVM)) {
                        UserListItemView(name: user.name, tags: user.allTags)
                    }
                }.onDelete(perform: { offsets in
                    friendsVM.deleteFriends(at: offsets)
                })
            }.navigationTitle("Friendly Faces")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
