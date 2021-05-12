//
//  URLImageWidget.swift
//  URLImageWidget
//
//  Created by Dmytro Anokhin on 08/12/2020.
//

import WidgetKit
import SwiftUI
import Intents
import URLImage
import URLImageStore
import Combine


class Loader {

    static let shared = Loader()

    static let service: URLImageService = URLImageService(fileStore: URLImageFileStore(),
                                                          inMemoryStore: URLImageInMemoryStore())

    var entry: SimpleEntry? {
        didSet {
            guard let entry = entry else {
                return
            }

            let publisher = Loader.service.remoteImagePublisher(entry.url, identifier: nil)

            cancellable = publisher.sink(receiveCompletion: { result in
                WidgetCenter.shared.reloadAllTimelines()
            }, receiveValue: { imageInfo in
            })
        }
    }

    var cancellable: AnyCancellable?

    init() {
    }
}


struct Provider: IntentTimelineProvider {

    private func dummyEntry(for configuration: ConfigurationIntent) -> SimpleEntry {
        .init(date: Date(),
              configuration: configuration,
              url: URL(string: "https://homepages.cae.wisc.edu/~ece533/images/arctichare.png")!)
    }

    func placeholder(in context: Context) -> SimpleEntry {
        dummyEntry(for: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = dummyEntry(for: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        if let entry = Loader.shared.entry {
            let timeline = Timeline(entries: [ entry ], policy: .atEnd)
            completion(timeline)
        }
        else {
            let entry = dummyEntry(for: configuration)
            Loader.shared.entry = entry

            let timeline = Timeline(entries: [ entry ], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {

    let date: Date

    let configuration: ConfigurationIntent

    let url: URL
}

struct URLImageWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        URLImage(entry.url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
        .environment(\.urlImageOptions, URLImageOptions(fetchPolicy: .returnStoreDontLoad))
        .environment(\.urlImageService, Loader.service)
    }
}

@main
struct URLImageWidget: Widget {
    let kind: String = "URLImageWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            URLImageWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

//struct URLImageWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        URLImageWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
