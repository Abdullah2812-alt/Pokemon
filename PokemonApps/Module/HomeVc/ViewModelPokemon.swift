//
//  ViewModelPokemon.swift
//  PokemonApps
//
//  Created by Kings on 09/08/25.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModelPokemon {
    
    private let getLocalPokemonUseCase: GetLocalPokemonUseCase
    private let syncRemotePokemonUseCase: SyncRemotePokemonUseCase
    private let disposeBag = DisposeBag()
    
    let pokemons = BehaviorRelay<[Pokemon]>(value: [])
    let isSyncing = BehaviorRelay<Bool>(value: false)
    let errorMessage = PublishRelay<String>()
    
    private var allPokemonFromLocal: [Pokemon] = []
    init(getLocalPokemonUseCase: GetLocalPokemonUseCase, syncRemotePokemonUseCase: SyncRemotePokemonUseCase) {
        self.getLocalPokemonUseCase = getLocalPokemonUseCase
        self.syncRemotePokemonUseCase = syncRemotePokemonUseCase
        
        self.pokemons
            .subscribe(onNext: { [weak self] pokemonList in
                self?.allPokemonFromLocal = pokemonList
            })
            .disposed(by: disposeBag)
    }
    
    func fetchData() {
        getLocalPokemonUseCase.execute()
            .subscribe(onNext: { [weak self] localPokemons in
                self?.pokemons.accept(localPokemons)
                if localPokemons.isEmpty {
                    self?.syncData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func syncData() {
        guard !isSyncing.value else { return }
        
        isSyncing.accept(true)
        
        syncRemotePokemonUseCase.execute()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] freshPokemons in
                    self?.pokemons.accept(freshPokemons)
                },
                onError: { [weak self] error in
                    self?.errorMessage.accept("Gagal sinkronisasi data.")
                },
                onCompleted: { [weak self] in
                    self?.isSyncing.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func filterPokemon(with query: String) {
        if query.isEmpty {
            pokemons.accept(allPokemonFromLocal)
        } else {
            let results = allPokemonFromLocal.filter {
                $0.name.lowercased().contains(query.lowercased())
            }
            pokemons.accept(results)
        }
    }
}
