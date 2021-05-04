//
//  FeedListView.swift
//  ImageOfTheDay
//
//  Created by Dmytro Anokhin on 01/05/2021.
//

import SwiftUI

struct FeedListView: View {

    let feedList: FeedListObject

    var body: some View {
        NavigationView {
            List(feedList.feedDescriptions) { feedDescription in
                NavigationLink(destination: FeedContainerView(feedList: feedList, feedDescription: feedDescription)) {
                    Text(feedDescription.name)
                }
            }
            .navigationTitle(Text("Feeds"))
        }
    }
}

struct FeedList_Previews: PreviewProvider {
    static var previews: some View {
        FeedListView(feedList: FeedListObject())
    }
}
