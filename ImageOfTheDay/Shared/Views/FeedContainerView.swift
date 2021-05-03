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
            .navigationBarTitle(feedObject.feedDescription.name, displayMode: .inline)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedContainerView(feedObject: FeedObject.shared)
//    }
//}
