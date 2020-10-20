//
//  ListDemoPresentationView.swift
//  URLImageDemo
//
//  Created by Dmytro Anokhin on 20/10/2020.
//

import SwiftUI
import URLImage


struct ListDemoPresentationView: View {

    let urls: [URL]

    init(urls: [URL]) {
        self.urls = urls
    }

    var body: some View {
        ListDemoView(urls: urls, options: appConfiguration.urlImageOptions)
            .navigationBarTitle("List")
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


struct ListDemoPresenterView_Previews: PreviewProvider {
    static var previews: some View {
        ListDemoPresentationView(urls: SampleURLs.midRes50.urls)
    }
}
