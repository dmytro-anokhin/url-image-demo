//
//  FeedListObject.swift
//  ImageOfTheDay
//
//  Created by Dmytro Anokhin on 04/05/2021.
//

import Foundation
import Combine


final class FeedListObject: ObservableObject {

    /// Returns the list of feeds bundled with the app
    static func getFeeds() -> [FeedDescription] {

        let bundle = Bundle(for: FeedObject.self)

        guard let fileURL = bundle.url(forResource: "Feeds", withExtension: "json") else {
            assertionFailure("Can not find Feeds.plist in \(bundle)")
            return []
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()

            return try decoder.decode([FeedDescription].self, from: data)
        }
        catch {
            assertionFailure("\(error)")
            return []
        }
    }

    let feedDescriptions: [FeedDescription]
    
    init() {
        feedDescriptions = FeedListObject.getFeeds()
    }

    /// Creates a feed object and keeps internal reference to it
    func feedObject(for feedDescription: FeedDescription) -> FeedObject {
        if let existingObject = feeds[feedDescription] {
            return existingObject
        }

        let newObject = FeedObject(feedDescription: feedDescription)
        feeds[feedDescription] = newObject

        return newObject
    }

    /// Map of feeds filled in lazily
    private var feeds: [FeedDescription: FeedObject] = [:]
}
