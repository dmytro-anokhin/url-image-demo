//
//  ItemView.swift
//  ImageOfTheDay
//
//  Created by Dmytro Anokhin on 18/03/2021.
//

import SwiftUI
import URLImage


struct ItemView: View {

    let item: Item

    var body: some View {
        Color("ItemViewBackground")
            .frame(height: Geometry.height)
            .overlay(image)
            .clipped()
            .overlay(text, alignment: .bottomLeading)
    }

    private enum Geometry {

        static let height: CGFloat = 300.0

        static let textPadding = EdgeInsets(top: 2.0, leading: 8.0, bottom: 2.0, trailing: 8.0)
    }

    private var image: some View {
        URLImage(item.imageURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }

    private var text: some View {
        Text(item.title)
            .font(.headline)
            .padding(Geometry.textPadding)
            .background(Color("ItemViewTextBackground"))
    }
}


struct ItemView_Previews: PreviewProvider {

    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            ItemView(item: Item.preview)
                .preferredColorScheme($0)
        }
    }
}


fileprivate extension Item {

    static let preview = Item(title: "Bernard Harris: First African American Spacewalker",
//                              content: "A physician, flight surgeon, and NASA astronaut, Bernard Harris became the first African American to perform a spacewalk in February 1995.",
                              imageURL: URL(string: "http://www.nasa.gov/sites/default/files/thumbnails/image/sts063-21-013.jpg")!,
                              id: "http://www.nasa.gov/image-feature/bernard-harris-first-african-american-spacewalker")
}
