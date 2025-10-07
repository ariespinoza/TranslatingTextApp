//
//  CountryCardDetailView.swift
//  TranslatingTextApp
//
//  Created by Emmy Molina Palma on 6/10/25.
//

import SwiftUI
import Translation

/// Pantalla de detalle: situaciones + frases con botón “Traducir” (Replace)
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
        // UI nativa con Replace: al aceptar, reemplazamos en el modelo
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
