//
//  FeedDescription.swift
//  ImageOfTheDay
//
//  Created by Dmytro Anokhin on 29/04/2021.
//

import Foundation


/// The description contains various information about a feed
struct FeedDescription: Identifiable, Codable {

    var id: Int

    var name: String

    var url: URL
}
