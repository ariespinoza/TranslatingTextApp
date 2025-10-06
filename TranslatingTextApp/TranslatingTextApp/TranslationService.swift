//
//  TranslationService.swift
//  TranslatingTextApp
//
//  Created by Alumno on 06/10/25.
//

import Foundation
import Translation

enum AppTranslationError: Error {
    case emptyResponse
    case unsupportedPair
}

/// Servicio minimalista para traducción on-device con TranslationSession
@available(iOS 17.4, macOS 14.4, *)
final class TranslationService {

    /// Traduce un texto. Si `installedSource` es nil, se autodetecta.
    func translate(
        _ text: String,
        target: Locale.Language,
        installedSource: Locale.Language? = nil
    ) async throws -> String {
        // Si quieres autodetección de origen, crea la sesión SOLO con target
        let session: TranslationSession = {
            if let installedSource {
                return TranslationSession(installedSource: installedSource, target: target)
            } else {
                return TranslationSession(target: target)
            }
        }()

        let resp = try await session.translate(text)
        guard !resp.targetText.isEmpty else { throw AppTranslationError.emptyResponse }
        return resp.targetText
    }

    /// Traduce un batch de textos, conservando el orden con clientIdentifier.
    func translateBatch(
        _ texts: [String],
        target: Locale.Language,
        installedSource: Locale.Language? = nil
    ) async throws -> [String] {
        let session: TranslationSession = {
            if let installedSource {
                return TranslationSession(installedSource: installedSource, target: target)
            } else {
                return TranslationSession(target: target)
            }
        }()

        let requests: [TranslationSession.Request] = texts.enumerated().map {
            .init(sourceText: $0.element, clientIdentifier: String($0.offset))
        }

        var outputs = Array(repeating: "", count: texts.count)
        for try await resp in session.translate(batch: requests) {
            if let id = resp.clientIdentifier, let idx = Int(id) {
                outputs[idx] = resp.targetText
            }
        }
        return outputs
    }

    /// Checa si un par origen→destino está soportado/instalado.
    func isSupported(from source: Locale.Language, to target: Locale.Language) async -> Bool {
        let status = await LanguageAvailability().status(from: source, to: target)
        switch status {
        case .installed, .supported: return true
        case .unsupported: return false
        @unknown default: return false
        }
    }

    /// Descarga modelos (hoja del sistema) para uso offline.
    func prepareDownload(from source: Locale.Language, to target: Locale.Language) async throws {
        // Este inicializador requiere ambos idiomas (no autodetección)
        let session = TranslationSession(installedSource: source, target: target)
        try await session.prepareTranslation()
    }

    /// Lista de idiomas soportados (para poblar Pickers).
    func supportedLanguages() async -> [Locale.Language] {
        await LanguageAvailability().supportedLanguages
    }
}
