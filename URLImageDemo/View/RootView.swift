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
            ListDemoView(urls: SampleURLs.sample50)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
