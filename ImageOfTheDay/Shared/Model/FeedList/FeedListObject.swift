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

    /// Singleton for demo purposes.
    ///
    /// Shared object used to simulate background refresh. Because the app doesn't implement persistence in any form, background tasks can use shared property to update content. This is sufficient to test downloads without adding complexity unnecessary in a demo app.
    static let shared = FeedListObject()

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

    /// Refresh content of all feeds including images
    func refresh(_ completion: ((_ success: Bool) -> Void)? = nil) {
        // TODO: Implement
        completion?(true)
    }

    func cancelRefresh() {
        // TODO: Implement
    }

    /// Map of feeds filled in lazily
    private var feeds: [FeedDescription: FeedObject] = [:]
}
