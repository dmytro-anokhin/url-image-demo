//
//  ContentView.swift
//  URLImageCompanionWatchApp Extension
//
//  Created by Dmytro Anokhin on 23/10/2020.
//

import SwiftUI
import URLImage


struct ContentView: View {

    static func picsum(range: Range<Int>) -> [URL] {
        range.map { URL(string: "https://picsum.photos/\($0)")! }
    }

    let urls: [URL] = ContentView.picsum(range: 200..<210)

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
                        .frame(width: 200.0, height: 200.0)
                        .clipped()

                        Text(url.absoluteString)
                    }
                }
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
