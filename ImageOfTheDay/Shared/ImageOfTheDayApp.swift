//
//  ImageOfTheDayApp.swift
//  Shared
//
//  Created by Dmytro Anokhin on 15/02/2021.
//

import SwiftUI
import URLImage
import URLImageStore


@main
struct ImageOfTheDayApp: App {

    var body: some Scene {

        let fileStore = URLImageFileStore()
        let inMemoryStore = URLImageInMemoryStore()
        let urlImageService = URLImageService(fileStore: fileStore, inMemoryStore: inMemoryStore)

        return WindowGroup {
            ContentView()
                .environment(\.urlImageService, urlImageService)
        }
    }
}
