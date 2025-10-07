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
                            title: country.name,
                            imageName: country.name.lowercased())
                    }
                    .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Países")
        }
    }
}
#Preview {
    ContentView()
}
