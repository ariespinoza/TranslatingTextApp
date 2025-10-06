//
//  TranslateEditorView.swift
//  TranslatingTextApp
//
//  Created by Alumno on 06/10/25.
//

import SwiftUI
import Translation

@available(iOS 17.4, macOS 14.4, *)
struct TranslateView: View {
    @StateObject private var vm = TranslateViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section("Texto") {
                    TextField("Escribe el texto a traducir…", text: $vm.sourceText, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }

                Section("Idiomas") {
                    Toggle("Autodetectar idioma origen", isOn: $vm.autodetectSource)
                        .onChange(of: vm.autodetectSource) { _ in
                            // Solo visual; la autodetección la controla el servicio al pasar nil
                        }

                    if !vm.autodetectSource {
                        Picker("Origen", selection: Binding(
                            get: { vm.selectedSource ?? vm.languages.first ?? Locale.Language() },
                            set: { vm.selectedSource = $0 }
                        )) {
                            ForEach(vm.languages, id: \.self) { lang in
                                Text(vm.languageLabel(lang)).tag(lang)
                            }
                        }

                        Picker("Destino", selection: $vm.selectedTarget) {
                            ForEach(vm.languages, id: \.self) { lang in
                                Text(vm.languageLabel(lang)).tag(lang)
                            }
                        }

                    Button("Descargar modelos para uso offline") {
                        vm.downloadModels()
                    }
                    .disabled(vm.autodetectSource || vm.selectedSource == nil)
                    .help("Requiere un idioma de origen explícito (no autodetección).")
                }

                Section("Acciones") {
                    HStack {
                        Button(vm.isLoading ? "Traduciendo…" : "Traducir") {
                            vm.translateOnce()
                        }
                        .disabled(vm.isLoading || vm.sourceText.isEmpty)

                        Button("Batch demo") {
                            vm.translateBatchDemo()
                        }
                        .disabled(vm.isLoading)
                    }
                }

                if let err = vm.errorMessage, !err.isEmpty {
                    Section("Error") {
                        Text(err).foregroundStyle(.red)
                    }
                }

                Section("Resultado") {
                    Text(vm.resultText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.quaternary))
                        .textSelection(.enabled)
                }
            }
            .navigationTitle("Traducción (Custom)")
            .task { vm.loadLanguages() }
        }
    }
}
