//
//  Issue96View.swift
//  URLImageDemo
//
//  Created by Dmytro Anokhin on 26/10/2020.
//

import SwiftUI
import URLImage


struct Issue96View: View {

    static let fishURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Redear_sunfish_FWS_1.jpg/277px-Redear_sunfish_FWS_1.jpg")!
    static let horseURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/97/Zaniskari_Horse_in_Ladhak%2C_Jammu_and_kashmir.jpg/320px-Zaniskari_Horse_in_Ladhak%2C_Jammu_and_kashmir.jpg")!

    @State var url = fishURL
    @State var show = true

    private let placeholder: some View = Image(systemName: "photo")
        .foregroundColor(.white)

    var body: some View {
        Text("If you tap 'Show horse' below it shows just the placeholder. If you try to toggle back and forth between the fish and horse the placeholder is always shown for the horse even though the image has been retrieved.")
            .padding()

        if show {
            URLImage(url: url,
                     options: appConfiguration.urlImageOptions,
                     empty: {
                        placeholder
                     },
                     inProgress: { _ in
                        placeholder
                     },
                     failure: { error, retry in
                        placeholder
                     },
                     content: { image in
                        image
                     }
            )
            .foregroundColor(.white)
            .grayscale(0.3)
            .frame(width: 150, height: 150)
            .clipped()

        }
        Button(action: {
            withAnimation{
                url = url.absoluteString.contains("sunfish") ? Issue96View.horseURL : Issue96View.fishURL
            }
        }, label: {
            Text("Show \(url.absoluteString.contains("sunfish") ? "horse" : "fish")")
        })

        Text("When the placeholder is visible (important), if you tap 'Hide image' below, and then tap 'Show image', it will only then correctly show the horse and toggling between the two images will work as expected.")
            .padding()

        Button(action: {
            withAnimation{
                self.show.toggle()
            }
        }, label: {
            Text(show == true ? "Hide image" : "Show image")
        })
    }

    @EnvironmentObject private var appConfiguration: AppConfiguration
}
