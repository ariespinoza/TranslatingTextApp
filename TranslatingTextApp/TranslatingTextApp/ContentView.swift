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
                        CountryDetailView(country: $vm.countries[idx])
                    } label: {
                        HStack(spacing: 12) {
                            Text(country.flag ?? "")
                            Text(country.name)
                                .font(.headline)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Países")
        }
    }
}
