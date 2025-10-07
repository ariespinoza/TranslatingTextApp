//
//  CountryCard.swift
//  TranslatingTextApp
//
//  Created by Emmy Molina Palma on 6/10/25.
//

import SwiftUI

/// Tarjeta con imagen de fondo y título superpuesto
struct CountryCardView: View {
    let title: String
    let imageName: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            cardImage
                .frame(maxWidth: .infinity, minHeight: 140, maxHeight: 180)
                .clipped()
                .overlay(
                    LinearGradient(
                        colors: [Color.black.opacity(0.05), Color.black.opacity(0.55)],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .cornerRadius(16)

            Text(title)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)
                .shadow(radius: 6)
                .padding(.leading, 16)
                .padding(.bottom, 14)
        }
    }

    // Aplica .resizable/.scaledToFill sólo cuando hay Image real
    @ViewBuilder
    private var cardImage: some View {
        #if canImport(UIKit)
        if let ui = UIImage(named: imageName) {
            Image(uiImage: ui)
                .resizable()
                .scaledToFill()
        } else {
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
