//
//  RootView.swift
//  URLImageDemo
//
//  Created by Dmytro Anokhin on 17/10/2020.
//

import SwiftUI

struct RootView: View {

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Collections")) {
                    NavigationLink(destination: ListDemoView(urls: SampleURLs.sample50)) {
                        Text("List")
                    }
                    if #available(iOS 14.0, *) {
                        NavigationLink(destination: ScrollableLazyVStackDemoView(urls: SampleURLs.sample50)) {
                            Text("Scrollable LazyVStack")
                        }
                    }
                }
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
