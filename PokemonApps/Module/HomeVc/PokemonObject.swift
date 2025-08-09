//
//  PokemonObject.swift
//  PokemonApps
//
//  Created by Kings on 09/08/25.
//

import Foundation
import RealmSwift

class PokemonObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var url: String
}
