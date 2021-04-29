//
//  FeedDescription.swift
//  ImageOfTheDay
//
//  Created by Dmytro Anokhin on 29/04/2021.
//

import Foundation


/// The description contains various information about a feed
struct FeedDescription: Codable {

    var name: String

    var url: URL
}
