//
//  AppConfiguration.swift
//  URLImageDemo
//
//  Created by Dmytro Anokhin on 18/10/2020.
//

import Combine
import CoreGraphics
import URLImage


final class AppConfiguration: ObservableObject {

    struct GridConfiguration {

        var length: CGFloat = 200.0
    }

    @Published var gridConfiguration = GridConfiguration()

    @Published var urlImageOptions = URLImageService.shared.defaultOptions

    deinit {
        "deinit"
    }
}
