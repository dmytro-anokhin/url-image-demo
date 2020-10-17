//
//  SampleURLs.swift
//  URLImageDemo
//
//  Created by Dmytro Anokhin on 17/10/2020.
//

import Foundation


enum SampleURLs {

    var sample50: [URL] { picsum(range: 500..<550) }

    func picsum(range: Range<Int>) -> [URL] {
        range.map { URL(string: "https://picsum.photos/\($0)")! }
    }
}
