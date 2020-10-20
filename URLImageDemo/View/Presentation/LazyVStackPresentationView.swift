//
//  LazyVStackPresentationView.swift
//  URLImageDemo
//
//  Created by Dmytro Anokhin on 20/10/2020.
//

import SwiftUI
import URLImage


@available(iOS 14.0, *)
struct LazyVStackPresentationView: View {

    let urls: [URL]

    init(urls: [URL]) {
        self.urls = urls
    }

    var body: some View {
        LazyVStackDemoView(urls: urls, options: appConfiguration.urlImageOptions)
            .navigationBarTitle("LazyVStack")
            .navigationBarItems(trailing: Button(action: {
                isURLImageOptionsSheetPresented = true
            }, label: {
                Image(systemName: "info.circle")
                    .imageScale(.large)
                    .frame(minWidth: 44.0, minHeight: 44.0)
            }))
            .sheet(isPresented: $isURLImageOptionsSheetPresented) {
                NavigationView {
                    URLImageOptionsView()
                        .navigationBarTitle("URLImageOptions", displayMode: .inline)
                        .navigationBarItems(leading: Button("Done") {
                            isURLImageOptionsSheetPresented = false
                        }
                        .frame(minWidth: 44.0, minHeight: 44.0))
                }
            }
    }

    @EnvironmentObject private var appConfiguration: AppConfiguration

    @State private var isURLImageOptionsSheetPresented = false
}


@available(iOS 14.0, *)
struct LazyVStackPresentationView_Previews: PreviewProvider {
    static var previews: some View {
        LazyVStackPresentationView(urls: SampleURLs.midRes50.urls)
    }
}
