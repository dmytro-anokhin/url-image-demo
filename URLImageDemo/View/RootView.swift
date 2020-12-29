//
//  RootView.swift
//  URLImageDemo
//
//  Created by Dmytro Anokhin on 17/10/2020.
//

import SwiftUI
import URLImage


struct RootView: View {

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sample")) {
                    Picker("Sample Size", selection: $sample) {
                        Text("50 images, 500px").tag(SampleURLs.midRes50)
                        Text("50 images, 1000px").tag(SampleURLs.highRes50)
                        Text("50 images, 2500px").tag(SampleURLs.higherRes50)
                        Text("1000 images, ≥500px").tag(SampleURLs.largeSet)
                    }
                }
                Section(header: Text("URLImage")) {
                    NavigationLink(
                        destination: URLImageOptionsView(isRemoveCachedImagesButtonVisible: false)
                            .navigationBarTitle("Default Options"),
                        label: {
                            Text("Default Options")
                        })
                    Button("Remove Cached Images") {
                        URLImageService.shared.removeAllCachedImages()
                    }
                }
                Section(header: Text("Collections")) {
                    NavigationLink(destination: ListDemoPresentationView(urls: sample.urls)) {
                        Text("List")
                    }
                    if #available(iOS 14.0, *) {
                        NavigationLink(destination: LazyVStackPresentationView(urls: sample.urls)) {
                            Text("LazyVStack")
                        }
                    }
                    if #available(iOS 14.0, *) {
                        NavigationLink(destination: LazyVGridDemoPresentationView(urls: sample.urls)) {
                            Text("LazyVGridDemoView")
                        }
                    }
                }
                Section(header: Text("Issues")) {
                    NavigationLink(destination: Issue96View()) {
                        Text("Issue 96")
                    }
                    NavigationLink(destination: Issue107View(url: sample.urls.first!)) {
                        Text("Issue 107")
                    }
                    NavigationLink(destination: Issue119View()) {
                        Text("Issue 119")
                    }
                }
            }
            .navigationBarTitle("URLImage Demo")
        }
    }

    @EnvironmentObject private var appConfiguration: AppConfiguration

    @State private var sample: SampleURLs = .midRes50
}


struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
