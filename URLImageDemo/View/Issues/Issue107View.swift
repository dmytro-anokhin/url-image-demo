//
//  Issue107View.swift
//  URLImageDemo
//
//  Created by Dmytro Anokhin on 09/11/2020.
//

import SwiftUI
import URLImage


struct Issue107View: View {

    let url: URL

    var body: some View {
        VStack {
            Text("The view loads an image from the same URL every time. Before every load previous image is removed from cache. Expected that a new image appears every time.")
            URLImage(url: url,
                     options: appConfiguration.urlImageOptions) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            Text("URL = \(url), Counter = \(counter)")
            Button("Load") {
                URLImageService.shared.removeImageWithURL(url)
                counter += 1
            }
        }
    }

    @State private var counter = 0

    @EnvironmentObject private var appConfiguration: AppConfiguration
}
