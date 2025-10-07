//
//  CountryCardDetailView.swift
//  TranslatingTextApp
//
//  Created by Emmy Molina Palma on 6/10/25.
//

import SwiftUI
import Translation

// Situation + Phrases view with the “Traducir” (Replace) button
struct CountryCardDetailView: View {
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
        //we see the situation with the phrases and the "Traducir" button, what we see when we click on a country.
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
        .navigationTitle(cleanCountryName(country.name))
        // native UI with Replace: when we accept, it gets replaced in the model
        .translationPresentation(isPresented: isPresentingTranslation, text: presentingText) { translated in
            if let path = selectedPath {
                country.situations[path.situation].phrases[path.phrase].text = translated
            }
        }
    }

    // MARK: - Helpers
    private func cleanCountryName(_ raw: String) -> String {
        raw.replacingOccurrences(of: #" *\(.+\)"#, with: "", options: .regularExpression)
    }
}
