//
//  CountryDetailView.swift
//  TranslatingTextApp
//
//  Created by Alumno on 06/10/25.
//

import SwiftUI
import Translation

struct CountryDetailView: View {
    @Binding var country: Country

    // we save the index that we are replacing when the user presses “Traducir”
    @State private var selectedPath: (situation: Int, phrase: Int)?
    @State private var presentingText: String = ""

    private var isPresentingTranslation: Binding<Bool> {
        Binding(
            get: { selectedPath != nil },
            set: { newVal in if newVal == false { selectedPath = nil } }
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
            // native Apple UI with “Replace Translation”
            .translationPresentation(isPresented: isPresentingTranslation, text: presentingText) { translated in
                // we replace the text and use the saved indexes
                if let path = selectedPath {
                    country.situations[path.situation].phrases[path.phrase].text = translated
                }
            }
    }
}
