//
//  PokemonDetailObject.swift
//  PokemonApps
//
//  Created by Kings on 10/08/25.
//

import Foundation
import RealmSwift

class PokemonDetailObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var imageURL: String?
    @Persisted var abilities = List<String>() 
}
