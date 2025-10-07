//
//  TripNote.swift
//  TranslatingTextApp
//
//  Created by Alumno on 06/10/25.
//

import Foundation

struct Phrase: Identifiable, Hashable {
    var id = UUID()
    var text: String
}

struct Situation: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var phrases: [Phrase] // to add the different phrases inside the situacion
}

struct Country: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var situations: [Situation] // to add the different situations to each country
}
