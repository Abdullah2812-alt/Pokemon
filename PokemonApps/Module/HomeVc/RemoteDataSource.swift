//
//  RemoteDataSource.swift
//  PokemonApps
//
//  Created by Kings on 09/08/25.
//

import Foundation
import Alamofire
import RxSwift

private struct PokemonListResponse: Codable {
    let results: [PokemonResultResponse]
}

private struct PokemonResultResponse: Codable {
    let name: String
    let url: String
}

private struct PokemonDetailResponse: Codable {
    let id: Int
    let name: String
    let sprites: SpriteInfoResponse
    let abilities: [AbilityItemResponse]
}

private struct SpriteInfoResponse: Codable {
    let other: OtherSpritesResponse
}

private struct OtherSpritesResponse: Codable {
    let officialArtwork: OfficialArtworkResponse
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

private struct OfficialArtworkResponse: Codable {
    let frontDefault: String?
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

private struct AbilityItemResponse: Codable {
    let ability: AbilityResponse
    let isHidden: Bool
    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
    }
}

private struct AbilityResponse: Codable {
    let name: String
}


class RemoteDataSource {
    
    func getPokemons() -> Observable<[Pokemon]> {
        return Observable.create { observer in
            let url = "https://pokeapi.co/api/v2/pokemon?limit=151"
            let request = AF.request(url).responseDecodable(of: PokemonListResponse.self) { response in
                switch response.result {
                case .success(let data):
                    let pokemons = data.results.map { result -> Pokemon in
                        let id = Int(URL(string: result.url)!.lastPathComponent) ?? 0
                        return Pokemon(id: id, name: result.name, url: result.url)
                    }
                    observer.onNext(pokemons)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create { request.cancel() }
        }
    }
    
    func getPokemonDetail(url: String) -> Observable<PokemonDetail> {
        return Observable.create { observer in
            
            let request = AF.request(url).responseDecodable(of: PokemonDetailResponse.self) { response in
                switch response.result {
                case .success(let apiData):
                    
                    let abilityNames = apiData.abilities.map { item -> String in
                        if item.isHidden {
                            return "\(item.ability.name.capitalized) (Hidden)"
                        } else {
                            return item.ability.name.capitalized
                        }
                    }
                    
                    let cleanDetail = PokemonDetail(
                        id: apiData.id,
                        name: apiData.name.capitalized,
                        imageURL: apiData.sprites.other.officialArtwork.frontDefault,
                        abilities: abilityNames
                    )
                    
                    observer.onNext(cleanDetail)
                    observer.onCompleted()
                    
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create { request.cancel() }
        }
    }
}
