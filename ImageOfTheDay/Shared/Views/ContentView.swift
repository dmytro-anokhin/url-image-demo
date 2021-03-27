//
//  ContentView.swift
//  Shared
//
//  Created by Dmytro Anokhin on 15/02/2021.
//

import SwiftUI

struct ContentView: View {

    @StateObject var feedObject = FeedObject()

    var body: some View {
        NavigationView {
            FeedView(feed: feedObject.feed)
                .onAppear {
                    feedObject.load()
                }
                .navigationTitle(Text("Title"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
