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

    @EnvironmentObject var appConfiguration: AppConfiguration

    let urls: [URL]

    var body: some View {

        let columns = [
            GridItem(.adaptive(minimum: appConfiguration.grid.length - appConfiguration.grid.length * 0.1,
                               maximum: appConfiguration.grid.length + appConfiguration.grid.length * 0.1))
        ]

        return ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(urls, id: \.self) { url in
                    URLImage(url: url) {
                        $0
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    .frame(height: appConfiguration.grid.length)
                    .clipped()
                }
            }
        }
    }
}


@available(iOS 14.0, *)
struct GridDemo_Previews: PreviewProvider {
    static var previews: some View {
        LazyVGridDemoView(urls: SampleURLs.midRes50.urls)
    }
}
