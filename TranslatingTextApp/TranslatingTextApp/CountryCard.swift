//
//  CountryCard.swift
//  TranslatingTextApp
//
//  Created by Emmy Molina Palma on 6/10/25.
//


import SwiftUI

/// Card with the image and the title in the front
struct CountryCardView: View {
    let title: String
    let imageName: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            cardImage
                .frame(maxWidth: .infinity, minHeight: 140, maxHeight: 180)
                .clipped()
                .overlay(
                    //Add a linear gradient to darker the image
                    LinearGradient(
                        colors: [Color.black.opacity(0.05), Color.black.opacity(0.55)],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .cornerRadius(16)

            //Add the title of the image, in this case the country
            Text(title)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)
                .shadow(radius: 6)
                .padding(.leading, 16)
                .padding(.bottom, 14)
        }
    }


    // Loads the picture and adapts it if needed
    @ViewBuilder
    private var cardImage: some View {
        #if canImport(UIKit)
        // if it finds the image it makes it resizable
        if let ui = UIImage(named: imageName) {
            Image(uiImage: ui)
                .resizable()
                .scaledToFill()
        } else {
            // if it doesn't find the picture it shows a gray background
            ZStack {
                Color.gray.opacity(0.25)
                Image(systemName: "photo")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundStyle(.gray)
            }
        }
        #else
        Image(imageName)
            .resizable()
            .scaledToFill()
        #endif
    }
}
