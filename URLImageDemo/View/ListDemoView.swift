//
//  ListDemoView.swift
//  URLImageDemo
//
//  Created by Dmytro Anokhin on 17/10/2020.
//

import SwiftUI
import URLImage


struct ListDemoView: View {

    let urls: [URL]

    var body: some View {
        List(urls, id: \.self) { url in
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

struct ListDemoView_Previews: PreviewProvider {
    static var previews: some View {
        ListDemoView(urls: SampleURLs.sample50)
    }
}
