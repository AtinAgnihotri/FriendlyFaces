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

struct ContentView: View {
    
    @ObservedObject var friendsVM = FriendsVM()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(friendsVM.people, id: \.id) { person in
                    NavigationLink(destination: Text(person.name)) {
                        UserListItemView(name: person.name, tags: person.allTags)
                    }
                }.onDelete(perform: { offsets in
                    friendsVM.deleteFriends(at: offsets)
                })
            }.navigationTitle("Hello")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
