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
    func getDetail(for pokemon: Pokemon) -> Observable<PokemonDetail>
    
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
    
    func getDetail(for pokemon: Pokemon) -> Observable<PokemonDetail> {
        return localDataSource.getDetail(for: pokemon.id)
            .flatMap { cachedDetail -> Observable<PokemonDetail> in
                if let detail = cachedDetail {
                    return Observable.just(detail)
                } else {
                    return self.remoteDataSource.getPokemonDetail(url: pokemon.url)
                        .do(onNext: { freshDetail in
                            self.localDataSource.saveDetail(from: freshDetail)
                        })
                }
            }
    }
}
