//
//  SampleURLs.swift
//  URLImageDemo
//
//  Created by Dmytro Anokhin on 17/10/2020.
//

import Foundation


enum SampleURLs: Int, CaseIterable, Identifiable {

    /// 50 images ~500px wide
    case midRes50

    /// 50 images ~1000px wide
    case highRes50

    /// 50 images ~2500px wide
    case higherRes50

    var id: Int {
        rawValue
    }

    var urls: [URL] {
        switch self {
            case .midRes50:
                return SampleURLs.picsum(range: 500..<550)
            case .highRes50:
                return SampleURLs.picsum(range: 1000..<1050)
            case .higherRes50:
                return SampleURLs.picsum(range: 2500..<2550)
        }
    }

    static func picsum(range: Range<Int>) -> [URL] {
        range.map { URL(string: "https://picsum.photos/\($0)")! }
    }
}
