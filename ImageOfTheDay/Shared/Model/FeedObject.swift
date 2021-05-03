//
//  FeedObject.swift
//  ImageOfTheDay
//
//  Created by Dmytro Anokhin on 16/02/2021.
//

import Combine
import CoreGraphics
import Foundation

import URLImage
import URLImageStore


final class FeedObject: ObservableObject {

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

    let feedDescription: FeedDescription

    init(feedDescription: FeedDescription) {
        self.feedDescription = feedDescription
    }

    @Published private(set) var feed = Feed(items: [])

    enum Error: Swift.Error {

        case network(_ error: URLError)

        case parse(_ error: Swift.Error)
    }

    func load(_ completion: ((_ success: Bool) -> Void)? = nil) {
        guard !isLoading else {
            return
        }

        cancellable = URLSession.shared
            .dataTaskPublisher(for: feedDescription.url)
            .mapError {
                Error.network($0)
            }
            .map {
                $0.data
            }
            .receive(on: DispatchQueue.global()) // Release URLSession queue
            .flatMap {
                FeedParser
                    .parse(data: $0)
                    .mapError {
                        Error.parse($0)
                    }
            }
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [weak self] _ in
                    guard let self = self else {
                        return
                    }

                    self.isLoading = false
                },
                receiveValue: { [weak self] feed in
                    guard let self = self else {
                        return
                    }

                    self.feed = feed
                    completion?(true)
                })
    }

    func loadImages(_ completion: ((_ success: Bool) -> Void)? = nil) {
        let store = URLImageFileStore()
        let urlImageService = URLImageService(fileStore: store, inMemoryStore: nil)

        let publishers = feed.items.map {
            urlImageService.remoteImagePublisher($0.imageURL, identifier: nil)
        }

        imageLoadingCancellable = Publishers.MergeMany(publishers)
            .tryMap { $0.cgImage }
            .catch { _ in
                Just(nil)
            }
            .collect()
            .sink { results in
                completion?(!results.contains(nil))
            }

        self.urlImageService = urlImageService
    }

    private var isLoading = false

    private var cancellable: AnyCancellable?

    private var parser: FeedParser?

    private var urlImageService: URLImageService?

    private var imageLoadingCancellable: AnyCancellable?
}
