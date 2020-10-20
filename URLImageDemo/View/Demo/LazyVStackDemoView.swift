//
//  LazyVStackDemoView.swift
//  URLImageDemo
//
//  Created by Dmytro Anokhin on 17/10/2020.
//

import SwiftUI
import URLImage

@available(iOS 14.0, *)
struct LazyVStackDemoView: View {

    let urls: [URL]

    let options: URLImageOptions

    init(urls: [URL], options: URLImageOptions) {
        self.urls = urls
        self.options = options
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(urls, id: \.self) { url in
                    VStack(alignment: .leading) {
                        URLImage(url: url, options: options) {
                            $0
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                        .frame(width: 200.0, height: 200.0)
                        .clipped()

                        Text(url.absoluteString)
                    }
                }
            }
        }
    }

    @EnvironmentObject private var appConfiguration: AppConfiguration
}

@available(iOS 14.0, *)
struct LazyVStackDemoView_Previews: PreviewProvider {
    static var previews: some View {
        LazyVStackDemoView(urls: SampleURLs.midRes50.urls, options: URLImageService.shared.defaultOptions)
    }
}
