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

    let url: URL

    init(url: URL = URL(string: FeedObject.list[0])!) {
        self.url = url
    }

    @Published private(set) var feed = Feed(items: [])

    func load() {
        
        guard let parser = FeedParser(url: url) else {
            return
        }

        self.parser = parser

        parser.parse { [weak self] result in
            guard let self = self else {
                return
            }

            print("parse complete with result: \(result)")

            switch result {
                case .success(let feed):
                    self.feed = feed

                case .failure:
                    self.feed = Feed(items: [])
            }
        }
    }

    private var parser: FeedParser?

    private var urlImageService: URLImageService?
    private var cancellables = Set<AnyCancellable>()

    private func loadImages(_ feed: Feed) {
        let store = URLImageFileStore()
        let urlImageService = URLImageService(fileStore: store, inMemoryStore: nil)

        for item in feed.items {
            urlImageService.remoteImagePublisher(item.imageURL)
                .tryMap {
                    $0
                }
                .catch { _ in
                    Just(nil)
                }
                .sink { _ in
                }
                .store(in: &self.cancellables)
        }

        self.urlImageService = urlImageService
    }
}
