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

    static let list = [
        "https://iso.500px.com/feed/",
        "https://www.nasa.gov/rss/dyn/lg_image_of_the_day.rss",
        "https://www.reddit.com/r/photojournalism/.rss?format=xml"
    ]

    static let shared = FeedObject()

    let url: URL

    init(url: URL = URL(string: FeedObject.list[0])!) {
        self.url = url
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
            .dataTaskPublisher(for: url)
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
