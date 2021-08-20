//
//  ContentView.swift
//  FriendlyFaces
//
//  Created by Atin Agnihotri on 19/08/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var friendsVM = FriendsVM()
    
    var body: some View {
        List {
            ForEach(friendsVM.people, id: \.id) { person in
                Text("\(person.name)")
            }
        }.navigationTitle("Hello")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
