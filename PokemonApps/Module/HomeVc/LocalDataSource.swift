//
//  LocalDataSource.swift
//  PokemonApps
//
//  Created by Kings on 09/08/25.
//

import Foundation
import RealmSwift
import RxSwift

class LocalDataSource {
    private let realm = try! Realm()

    func getPokemons() -> Observable<[Pokemon]> {
        let results = realm.objects(PokemonObject.self).sorted(byKeyPath: "id")
        
        let pokemons = results.map { realmObject -> Pokemon in
            return Pokemon(id: realmObject.id, name: realmObject.name, url: realmObject.url)
        }
        
        return Observable.just(Array(pokemons))
    }

    func savePokemons(from pokemons: [Pokemon]) {
        try! realm.write {
            realm.delete(realm.objects(PokemonObject.self))
            
            let pokemonObjects = pokemons.map { domainPokemon -> PokemonObject in
                let object = PokemonObject()
                object.id = domainPokemon.id
                object.name = domainPokemon.name
                object.url = domainPokemon.url
                return object
            }
            
            realm.add(pokemonObjects)
        }
    }
}
