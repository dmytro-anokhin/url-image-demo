//
//  FeedListView.swift
//  ImageOfTheDay
//
//  Created by Dmytro Anokhin on 01/05/2021.
//

import SwiftUI

struct FeedListView: View {

    let feeds: [FeedDescription] = FeedObject.getFeeds()

    var body: some View {
        NavigationView {
            List(feeds) { feedDescription in
                NavigationLink(destination: FeedContainerView(feedObject: FeedObject(feedDescription: feedDescription))) {
                    Text(feedDescription.name)
                }
            }
            .navigationTitle(Text("Feeds"))
        }
    }
}

struct FeedList_Previews: PreviewProvider {
    static var previews: some View {
        FeedListView()
    }
}
