//
//  AppConfiguration.swift
//  URLImageDemo
//
//  Created by Dmytro Anokhin on 18/10/2020.
//

import Combine
import CoreGraphics


final class AppConfiguration: ObservableObject {

    struct GridConfiguration {

        var length: CGFloat = 200.0
    }

    @Published var grid = GridConfiguration()
}
