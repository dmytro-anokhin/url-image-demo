//
//  RootView.swift
//  URLImageDemo
//
//  Created by Dmytro Anokhin on 17/10/2020.
//

import SwiftUI
import URLImage

struct RootView: View {

    @State var sample: SampleURLs = .midRes50

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Settings")) {
                    Picker("Sample", selection: $sample) {
                        Text("50 images, 500px").tag(SampleURLs.midRes50)
                        Text("50 images, 1000px").tag(SampleURLs.highRes50)
                        Text("50 images, 2500px").tag(SampleURLs.higherRes50)
                        Text("1000 images, ≥500px").tag(SampleURLs.largeSet)
                    }
                    Button("Remove Cached Images") {
                        URLImageService.shared.removeAllCachedImages()
                    }
                }
                Section(header: Text("Collections")) {
                    NavigationLink(destination: ListDemoView(urls: sample.urls)
                                                    .navigationBarTitle("List")) {
                        Text("List")
                    }
                    if #available(iOS 14.0, *) {
                        NavigationLink(destination: LazyVStackDemoView(urls: sample.urls)
                                                        .navigationBarTitle("LazyVStack")) {
                            Text("LazyVStack")
                        }
                    }
                    if #available(iOS 14.0, *) {
                        NavigationLink(destination: makeLazyVGridDemoView()) {
                            Text("LazyVGridDemoView")
                        }
                    }
                }
            }
            .navigationBarTitle("URLImage Demo")
        }
    }

    @available(iOS 14.0, *)
    private func makeLazyVGridDemoView() -> some View {
        LazyVGridDemoView(urls: sample.urls)
            .navigationBarTitle("LazyVGrid")
            .navigationBarItems(trailing: GridConfigurationView()
                                    .configurationSheet())
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
