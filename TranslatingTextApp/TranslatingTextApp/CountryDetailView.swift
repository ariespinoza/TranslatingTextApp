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

    // guardamos el índice a reemplazar cuando el usuario presiona “Traducir”
    @State private var selectedPath: (situation: Int, phrase: Int)?
    @State private var presentingText: String = ""

    // binding booleano para mostrar/ocultar la hoja nativa
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
        .navigationTitle(country.flag.map { "\($0) \(country.name)" } ?? country.name)
        // 🎯 UI nativa de Apple con “Replace Translation”
        .translationPresentation(isPresented: isPresentingTranslation, text: presentingText) { translated in
            // Reemplazamos el texto en el modelo usando los índices guardados
            if let path = selectedPath {
                country.situations[path.situation].phrases[path.phrase].text = translated
            }
        }
    }
}
