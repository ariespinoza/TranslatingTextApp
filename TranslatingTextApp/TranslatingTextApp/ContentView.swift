//
//  ContentView.swift
//  TranslatingTextApp
//
//  Created by Alumno on 06/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = TranslateViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.countries.indices, id: \.self) { idx in
                    let country = vm.countries[idx]
                    NavigationLink {
                        CountryCardDetailView(country: $vm.countries[idx])
                    } label: {
                        CountryCardView(
                            title: displayName(country.name),
                            imageName: imageName(for: country.name)
                        )
                    }
                    .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Países")
        }
    }

    // MARK: - Helpers
    /// Quita lo que esté entre paréntesis (ej. “(París, francés)”)
    private func displayName(_ raw: String) -> String {
        if let cut = raw.firstIndex(of: "(") {
            return String(raw[..<cut]).trimmingCharacters(in: .whitespaces)
        }
        return raw
    }

    /// Genera el nombre del asset: lowercased + sin diacríticos + sin paréntesis
    private func imageName(for raw: String) -> String {
        let base = displayName(raw)
        let folded = base.folding(options: .diacriticInsensitive, locale: .current)
        return folded.lowercased()
    }
}
#Preview {
    ContentView()
}
