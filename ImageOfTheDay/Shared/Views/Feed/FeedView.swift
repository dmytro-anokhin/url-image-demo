//
//  FeedView.swift
//  ImageOfTheDay
//
//  Created by Dmytro Anokhin on 16/02/2021.
//

import SwiftUI
import URLImage


struct FeedView: View {

    let feed: Feed

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(feed.items) {
                    ItemView(item: $0)
                }
            }
        }
        .environment(\.urlImageOptions, URLImageOptions(
            maxPixelSize: CGSize(width: 600.0, height: 600.0)
        ))
    }
}


struct FeedView_Previews: PreviewProvider {

    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            FeedView(feed: Feed.preview)
                .preferredColorScheme($0)
        }
    }
}


fileprivate extension Feed {

    static let preview = Feed(items: [
        Item(title: "Bernard Harris: First African American Spacewalker",
//             content: "A physician, flight surgeon, and NASA astronaut, Bernard Harris became the first African American to perform a spacewalk in February 1995.",
             imageURL: URL(string: "http://www.nasa.gov/sites/default/files/thumbnails/image/sts063-21-013.jpg")!,
             id: "http://www.nasa.gov/image-feature/bernard-harris-first-african-american-spacewalker"),

        Item(title: "Sunrise Over the Pacific",
//             content: "This view of a sunrise breaking through the Earth's horizon was taken as the International Space Station orbited 271 miles above the Pacific Ocean off the coast of southern Chile.",
             imageURL: URL(string: "http://www.nasa.gov/sites/default/files/thumbnails/image/iss064e029005.jpg")!,
             id: "http://www.nasa.gov/image-feature/sunrise-over-the-pacific")
    ])
}
