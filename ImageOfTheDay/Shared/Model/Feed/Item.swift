//
//  Item.swift
//  ImageOfTheDay
//
//  Created by Dmytro Anokhin on 16/02/2021.
//

import Foundation


/// An article or "story" in the feed.
struct Item {

    /// RSS `<title>` element
    ///
    /// Defines the title of the item
    ///
    /// `<title>Bernard Harris: First African American Spacewalker</title>`
    var title: String

    /// URL of the image
    ///
    /// Parsed RSS `<enclosure>` element
    ///
    /// `<enclosure url="http://www.nasa.gov/sites/default/files/thumbnails/image/sts063-21-013.jpg" length="6510628" type="image/jpeg" />`
    var imageURL: URL

    /// RSS `<guid>` element
    ///
    /// A unique identifier of the item
    var id: String
}


extension Item: Identifiable {
}
