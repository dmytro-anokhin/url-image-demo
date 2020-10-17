//
//  ScrollableLazyVStackDemoView.swift
//  URLImageDemo
//
//  Created by Dmytro Anokhin on 17/10/2020.
//

import SwiftUI
import URLImage

@available(iOS 14.0, *)
struct ScrollableLazyVStackDemoView: View {

    let urls: [URL]

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(urls, id: \.self) { url in
                    VStack(alignment: .leading) {
                        URLImage(url: url) {
                            $0
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                            .frame(width: 320.0, height: 200.0)
                            .clipped()
                        Text(url.absoluteString)
                    }
                }
            }
        }
    }
}

@available(iOS 14.0, *)
struct ScrollableLazyVStackDemoView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollableLazyVStackDemoView(urls: SampleURLs.sample50)
    }
}
