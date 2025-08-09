//
//  ModelPokemon.swift
//  PokemonApps
//
//  Created by Kings on 09/08/25.
//

import Foundation

struct ModelPokemon: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonResult]
}

struct PokemonResult: Codable {
    let name: String
    let url: String
}
