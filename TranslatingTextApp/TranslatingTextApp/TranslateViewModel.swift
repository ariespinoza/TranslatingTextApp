//
//  TranslateViewModel.swift
//  TranslatingTextApp
//
//  Created by Alumno on 06/10/25.
//

import SwiftUI
import Translation
import Combine

@available(iOS 17.4, macOS 14.4, *)
@MainActor
final class TranslateViewModel: ObservableObject {
    @Published var sourceText: String = "Hallo, Welt!"
    @Published var resultText: String = ""

    @Published var autodetectSource: Bool = true
    @Published var selectedSource: Locale.Language? = nil
    @Published var selectedTarget: Locale.Language = .init(identifier: "es_MX")

    @Published var languages: [Locale.Language] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let service = TranslationService()
    
    private func languageLabel(_ l: Locale.Language) -> String {
        // En algunos SDK no hay .identifier; String(describing:) siempre existe.
        // Queda algo tipo "en", "es", "fr" o representaciones similares.
        String(describing: l)
    }

    func loadLanguages() {
        Task {
            let langs = await service.supportedLanguages()

            // Ordena por etiqueta derivada (sin usar .identifier)
            self.languages = langs.sorted { a, b in
                languageLabel(a).localizedCompare(languageLabel(b)) == .orderedAscending
            }

            // Defaults sencillos sin depender de .identifier
            if self.selectedSource == nil {
                self.selectedSource = self.languages.first
            }

            // Si quieres intentar elegir español como destino:
            if let es = self.languages.first(where: { languageLabel($0).lowercased().hasPrefix("es") }) {
                self.selectedTarget = es
            } else if let first = self.languages.first {
                self.selectedTarget = first
            }
        }
    }

    func translateOnce() {
        Task {
            errorMessage = nil
            isLoading = true
            do {
                let out = try await service.translate(
                    sourceText,
                    target: selectedTarget,
                    installedSource: autodetectSource ? nil : selectedSource
                )
                resultText = out
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func translateBatchDemo() {
        Task {
            errorMessage = nil
            isLoading = true
            do {
                let samples = ["Guten Morgen", "Ich heiße Daniela", "Wo ist der Bahnhof?"]
                let outs = try await service.translateBatch(
                    samples,
                    target: selectedTarget,
                    installedSource: autodetectSource ? nil : selectedSource
                )
                resultText = outs.joined(separator: "\n• ")
                if !resultText.hasPrefix("• ") { resultText = "• " + resultText }
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    /// Descarga modelos para el par elegido (requiere origen explícito).
    func downloadModels() {
        guard let src = selectedSource else {
            errorMessage = "Selecciona un idioma de origen para descargar modelos."
            return
        }
        Task {
            errorMessage = nil
            isLoading = true
            do {
                try await service.prepareDownload(from: src, to: selectedTarget)
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
