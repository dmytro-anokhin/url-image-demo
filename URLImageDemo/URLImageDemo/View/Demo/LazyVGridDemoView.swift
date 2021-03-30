//
//  LazyVGridDemoView.swift
//  URLImageDemo
//
//  Created by Dmytro Anokhin on 17/10/2020.
//

import SwiftUI
import URLImage


@available(iOS 14.0, *)
struct LazyVGridDemoView: View {

    let urls: [URL]

    let options: URLImageOptions

    init(urls: [URL], options: URLImageOptions) {
        self.urls = urls
        self.options = options
    }

    var body: some View {

        let columns = [
            GridItem(.adaptive(minimum: appConfiguration.gridConfiguration.length - appConfiguration.gridConfiguration.length * 0.1,
                               maximum: appConfiguration.gridConfiguration.length + appConfiguration.gridConfiguration.length * 0.1))
        ]

        return ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(urls, id: \.self) { url in
                    URLImage(url: url, options: options) {
                        $0
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    .frame(height: appConfiguration.gridConfiguration.length)
                    .clipped()
                }
            }
        }
    }

    @EnvironmentObject private var appConfiguration: AppConfiguration
}


@available(iOS 14.0, *)
struct GridDemo_Previews: PreviewProvider {
    static var previews: some View {
        LazyVGridDemoView(urls: SampleURLs.midRes50.urls, options: URLImageService.shared.defaultOptions)
    }
}
