//
//  GetLocalPokemonUseCase.swift
//  PokemonApps
//
//  Created by Kings on 09/08/25.
//

import Foundation
import RxSwift

class GetLocalPokemonUseCase {
    private let repository: PokemonRepositoryProtocol
    init(repository: PokemonRepositoryProtocol) { self.repository = repository }
    func execute() -> Observable<[Pokemon]> {
        return repository.getPokemonsFromLocal()
    }
}
