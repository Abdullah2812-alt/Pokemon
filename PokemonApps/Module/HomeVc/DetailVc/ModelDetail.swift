//
//  ModelDetail.swift
//  PokemonApps
//
//  Created by Kings on 09/08/25.
//

import Foundation

struct Pokemon {
    let id: Int
    let name: String
    let url: String
}

struct PokemonDetail {
    let id: Int
    let name: String
    let imageURL: String?
    let abilities: [String]
}
