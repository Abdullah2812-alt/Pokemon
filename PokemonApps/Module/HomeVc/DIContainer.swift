//
//  DIContainer.swift
//  PokemonApps
//
//  Created by Kings on 09/08/25.
//

import Foundation

class DIContainer {
    static let shared = DIContainer()
    
    private func makeLocalDataSource() -> LocalDataSource {
        return LocalDataSource()
    }
    
    private func makeRemoteDataSource() -> RemoteDataSource {
        return RemoteDataSource()
    }
    
    private func makePokemonRepository() -> PokemonRepositoryProtocol {
        return PokemonRepository(
            localDataSource: makeLocalDataSource(),
            remoteDataSource: makeRemoteDataSource()
        )
    }
    
    private func makeGetLocalPokemonUseCase() -> GetLocalPokemonUseCase {
        return GetLocalPokemonUseCase(repository: makePokemonRepository())
    }
    
    private func makeSyncRemotePokemonUseCase() -> SyncRemotePokemonUseCase {
        return SyncRemotePokemonUseCase(repository: makePokemonRepository())
    }
    
    private func makeHomeViewModel() -> ViewModelPokemon {
        return ViewModelPokemon(
            getLocalPokemonUseCase: makeGetLocalPokemonUseCase(),
            syncRemotePokemonUseCase: makeSyncRemotePokemonUseCase()
        )
    }
    
    private func makeHomeViewController() -> HomeViewController {
        let vc = HomeViewController()
        vc.viewModel = makeHomeViewModel()
        return vc
    }
    private func makeProfileViewController() -> ProfileViewController {
        return ProfileViewController()
    }
    
    func makeMainTabBarController() -> TabbarVc {
        let homeVC = makeHomeViewController()
        let profileVC = makeProfileViewController()
        let tabBarController = TabbarVc(homeViewController: homeVC, profileViewController: profileVC)
        
        return tabBarController
    }
}
