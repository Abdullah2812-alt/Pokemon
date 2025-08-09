//
//  ViewModelDetail.swift
//  PokemonApps
//
//  Created by Kings on 09/08/25.
//

import Foundation
import Alamofire

private struct PokemonDetailResponse: Codable {
    let id: Int
    let name: String
    let sprites: SpriteInfoResponse
    let abilities: [AbilityItemResponse]
}
private struct SpriteInfoResponse: Codable {
    let other: OtherSpritesResponse
    enum CodingKeys: String, CodingKey { case other }
}
private struct OtherSpritesResponse: Codable {
    let officialArtwork: OfficialArtworkResponse
    enum CodingKeys: String, CodingKey { case officialArtwork = "official-artwork" }
}
private struct OfficialArtworkResponse: Codable {
    let frontDefault: String?
    enum CodingKeys: String, CodingKey { case frontDefault = "front_default" }
}
private struct AbilityItemResponse: Codable {
    let ability: AbilityResponse
    let isHidden: Bool
    enum CodingKeys: String, CodingKey {
        case ability, isHidden = "is_hidden"
    }
}
private struct AbilityResponse: Codable {
    let name: String
}


class ViewModelDetail {
    
    var pokemonName: String?
    var imageURL: String?
    var pokemonAbilities: [String] = []
    
    var onDataUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    func requestData(for url: String) {
        AF.request(url).responseDecodable(of: PokemonDetailResponse.self) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let apiDetail):
           
                self.pokemonName = apiDetail.name.capitalized
                self.imageURL = apiDetail.sprites.other.officialArtwork.frontDefault
                
                self.pokemonAbilities = apiDetail.abilities.map { item -> String in
                    let name = item.ability.name.capitalized
                    return item.isHidden ? "\(name) (Hidden)" : name
                }
                
                self.onDataUpdate?()
                
            case .failure(let error):
                print("Error fetching detail: \(error)")
                self.onError?(error)
            }
        }
    }
}
