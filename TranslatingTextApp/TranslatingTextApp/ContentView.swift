//
//  ContentView.swift
//  TranslatingTextApp
//
//  Created by Alumno on 06/10/25.
//

import SwiftUI
import Translation

struct ContentView: View {
    @StateObject private var vm = TranslateViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.countries.indices, id: \.self) { idx in
                    let country = vm.countries[idx]
                    NavigationLink {
                        CountryDetailViewLocal(country: $vm.countries[idx])
                    } label: {
                        CountryCard(title: displayName(country.name),
                                    imageName: imageName(for: country.name))
                    }
                    .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Países")
        }
    }

    // MARK: - helpers

    //shows the name of the country
    private func displayName(_ raw: String) -> String {
        if let cut = raw.firstIndex(of: "(") {
            return String(raw[..<cut]).trimmingCharacters(in: .whitespaces)
        }
        return raw
    }

    /// generate the name of the images in assets
    private func imageName(for raw: String) -> String {
        let base = displayName(raw)
        let folded = base.folding(options: .diacriticInsensitive, locale: .current)
        return folded.lowercased()
    }
}

// MARK: - card view to put the images with the name of the country in front
private struct CountryCard: View {
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

// MARK: - local detail compatible with view model

private struct CountryDetailViewLocal: View {
    @Binding var country: TranslateViewModel.Country

    @State private var selectedPath: (situation: Int, phrase: Int)?
    @State private var presentingText: String = ""

    private var isPresentingTranslation: Binding<Bool> {
        Binding(
            get: { selectedPath != nil },
            set: { if $0 == false { selectedPath = nil } }
        )
    }

    var body: some View {
        List {
            ForEach(country.situations.indices, id: \.self) { sIdx in
                Section(country.situations[sIdx].title) {
                    ForEach(country.situations[sIdx].phrases.indices, id: \.self) { pIdx in
                        let phrase = country.situations[sIdx].phrases[pIdx]
                        VStack(alignment: .leading, spacing: 8) {
                            Text(phrase.text)
                                .fixedSize(horizontal: false, vertical: true)

                            HStack {
                                Spacer()
                                Button("Traducir") {
                                    selectedPath = (sIdx, pIdx)
                                    presentingText = phrase.text
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
        }
        .navigationTitle(country.name.replacingOccurrences(of: #" *\(.+\)"#, with: "", options: .regularExpression))
        .translationPresentation(isPresented: isPresentingTranslation, text: presentingText) { translated in
            if let path = selectedPath {
                country.situations[path.situation].phrases[path.phrase].text = translated
            }
        }
    }
}
