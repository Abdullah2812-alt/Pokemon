//
//  GetPokemonDetailUseCase.swift
//  PokemonApps
//
//  Created by Kings on 10/08/25.
//

import Foundation
import RxSwift

class GetPokemonDetailUseCase {
    private let repository: PokemonRepositoryProtocol
    init(repository: PokemonRepositoryProtocol) { self.repository = repository }
    
    func execute(for pokemon: Pokemon) -> Observable<PokemonDetail> {
        return repository.getDetail(for: pokemon)
    }
}
