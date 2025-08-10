//
//  ViewModelDetail.swift
//  PokemonApps
//
//  Created by Kings on 09/08/25.
//

// ViewModelDetail.swift

import Foundation
import RxSwift
import RxCocoa


class ViewModelDetail {
    
    private let getPokemonDetailUseCase: GetPokemonDetailUseCase
    private let disposeBag = DisposeBag()
    
    let pokemonDetail = BehaviorRelay<PokemonDetail?>(value: nil)
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage = PublishRelay<String>()
    
    init(getPokemonDetailUseCase: GetPokemonDetailUseCase) {
        self.getPokemonDetailUseCase = getPokemonDetailUseCase
    }
  
    func fetchData(for pokemon: Pokemon) {
        isLoading.accept(true)
        getPokemonDetailUseCase.execute(for: pokemon)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] detail in
                    self?.pokemonDetail.accept(detail)
                },
                onError: { [weak self] error in
                    self?.errorMessage.accept("Gagal memuat detail.")
                },
                onCompleted: { [weak self] in
                    self?.isLoading.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
}
