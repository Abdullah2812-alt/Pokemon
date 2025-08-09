//
//  PokemonRepository.swift
//  PokemonApps
//
//  Created by Kings on 09/08/25.
//

import Foundation
import RxSwift
import RealmSwift

protocol PokemonRepositoryProtocol {
    func getPokemonsFromLocal() -> Observable<[Pokemon]>
    func syncPokemonsFromRemote() -> Observable<[Pokemon]>
}

class PokemonRepository: PokemonRepositoryProtocol {
    private let localDataSource: LocalDataSource
    private let remoteDataSource: RemoteDataSource

    init(localDataSource: LocalDataSource, remoteDataSource: RemoteDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    func getPokemonsFromLocal() -> Observable<[Pokemon]> {
        return localDataSource.getPokemons()
    }
    
    
    func syncPokemonsFromRemote() -> Observable<[Pokemon]> {
        return remoteDataSource.getPokemons()
            .do(onNext: { freshPokemons in
                self.localDataSource.savePokemons(from: freshPokemons)
            })
    }
}
