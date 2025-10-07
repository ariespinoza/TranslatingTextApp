//
//  CountryDetailView.swift
//  TranslatingTextApp
//
//  Created by Alumno on 06/10/25.
//

import SwiftUI
import Translation

struct CountryDetailView: View {
    // any edits here will update the main list
    @Binding var country: Country

    // keeps tharck of which phrase we're currently translating
    @State private var selectedPath: (situation: Int, phrase: Int)?
    @State private var presentingText: String = ""

    // show sheet if we have a selected phrase, hie it when set to nil
    private var isPresentingTranslation: Binding<Bool> {
        Binding(
            get: { selectedPath != nil },
            set: { newVal in if newVal == false { selectedPath = nil } }
        )
    }

    var body: some View {
        List {
            // loop through all the situations
            ForEach(country.situations.indices, id: \.self) { sIdx in
                Section(country.situations[sIdx].title) {
                    // loop through the situation's phrases
                    ForEach(country.situations[sIdx].phrases.indices, id: \.self) { pIdx in
                        let phrase = country.situations[sIdx].phrases[pIdx]
                        VStack(alignment: .leading, spacing: 8) {
                            Text(phrase.text)
                                .fixedSize(horizontal: false, vertical: true)

                            HStack {
                                Spacer()
                                Button("Traducir") {
                                    // guardamos path y texto actual para la hoja nativa
                                    selectedPath = (situation: sIdx, phrase: pIdx)
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
        .navigationTitle(country.name)
            // Apple's native translation sheet, it gives back the translated text
            .translationPresentation(isPresented: isPresentingTranslation, text: presentingText) { translated in
                // we replace the original phrase with the translated one
                if let path = selectedPath {
                    country.situations[path.situation].phrases[path.phrase].text = translated
                }
            }
    }
}
