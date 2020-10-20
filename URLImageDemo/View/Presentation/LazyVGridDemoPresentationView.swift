//
//  LazyVGridDemoPresentationView.swift
//  URLImageDemo
//
//  Created by Dmytro Anokhin on 20/10/2020.
//

import SwiftUI
import URLImage


@available(iOS 14.0, *)
struct LazyVGridDemoPresentationView: View {

    let urls: [URL]

    init(urls: [URL]) {
        self.urls = urls
    }

    var body: some View {
        LazyVGridDemoView(urls: urls, options: appConfiguration.urlImageOptions)
            .navigationBarTitle("LazyVGrid")
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    presentedSheet = .gridConfiguration
                }, label: {
                    Image(systemName: "gear")
                        .imageScale(.large)
                        .frame(minWidth: 44.0, minHeight: 44.0)
                })
                Button(action: {
                    presentedSheet = .urlImageOptions
                }, label: {
                    Image(systemName: "info.circle")
                        .imageScale(.large)
                        .frame(minWidth: 44.0, minHeight: 44.0)
                })
            })
            .sheet(item: $presentedSheet) { sheet in
                NavigationView {
                    ZStack {
                        switch sheet {
                            case .gridConfiguration:
                                GridConfigurationView()

                            case .urlImageOptions:
                                URLImageOptionsView()
                        }
                    }
                    .navigationBarTitle(sheet.rawValue, displayMode: .inline)
                    .navigationBarItems(leading: Button("Done") {
                        presentedSheet = nil
                    }
                    .frame(minWidth: 44.0, minHeight: 44.0))
                }
            }
    }

    @EnvironmentObject private var appConfiguration: AppConfiguration

    @State private var presentedSheet: Sheet?

    private enum Sheet: String, Identifiable {

        case gridConfiguration = "Grid Configuration"

        case urlImageOptions = "URLImageOptions"

        var id: String {
            rawValue
        }
    }
}


@available(iOS 14.0, *)
struct LazyVGridDemoPresentationView_Previews: PreviewProvider {

    static var previews: some View {
        LazyVGridDemoPresentationView(urls: SampleURLs.midRes50.urls)
    }
}
