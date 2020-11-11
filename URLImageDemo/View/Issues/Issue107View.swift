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
            URLImage(url: url,
                     options: appConfiguration.urlImageOptions) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            Text("Counter = \(counter)")
            Button("Next") {
                URLImageService.shared.removeImageWithURL(url)
                counter += 1
            }
        }
    }

    @State private var counter = 0

    @EnvironmentObject private var appConfiguration: AppConfiguration
}
