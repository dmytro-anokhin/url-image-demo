//
//  FeedContainerView.swift
//  Shared
//
//  Created by Dmytro Anokhin on 15/02/2021.
//

import SwiftUI

struct FeedContainerView: View {

    @ObservedObject var feedObject: FeedObject

    var body: some View {
        FeedView(feed: feedObject.feed)
            .onAppear {
                feedObject.load()
            }
            .navigationBarTitle(feedObject.feedDescription.name,
                                displayMode: .inline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let description = FeedDescription(id: 0,
                                          name: "NASA Image of the Day",
                                          url: URL(string: "https://www.nasa.gov/rss/dyn/lg_image_of_the_day.rss")!)
        return FeedContainerView(feedObject: FeedObject(feedDescription: description))
    }
}
