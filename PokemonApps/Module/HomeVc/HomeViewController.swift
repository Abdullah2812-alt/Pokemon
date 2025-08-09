//
//  HomeViewController.swift
//  PokemonApps
//
//  Created by Kings on 06/08/25.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    @IBOutlet weak var bgSeacrh: UIView!
    @IBOutlet weak var textFieldSeacrh: UITextField!
    @IBOutlet weak var imgClear: UIImageView!
    @IBOutlet weak var tableViewPokemon: UITableView!
    
    var viewModel: ViewModelPokemon!
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchData()
    }
    
    private func setupUI() {
        bgSeacrh.layer.cornerRadius = 10
        
        let nib = UINib(nibName: "PokemonTableViewCell", bundle: nil)
        tableViewPokemon.register(nib, forCellReuseIdentifier: "PokemonTableViewCell")
        
        tableViewPokemon.rowHeight = 50.0
        tableViewPokemon.alwaysBounceVertical = true
        tableViewPokemon.refreshControl = refreshControl
    }
    
    private func setupBindings() {
        textFieldSeacrh.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.viewModel.filterPokemon(with: query)
            })
            .disposed(by: disposeBag)
        
        textFieldSeacrh.rx.text.orEmpty
            .map { $0.isEmpty }
            .bind(to: imgClear.rx.isHidden)
            .disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer()
        imgClear.isUserInteractionEnabled = true
        imgClear.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.textFieldSeacrh.text = ""
                self?.textFieldSeacrh.sendActions(for: .valueChanged)
            })
            .disposed(by: disposeBag)
        
        viewModel.pokemons
            .bind(to: tableViewPokemon.rx.items(cellIdentifier: "PokemonTableViewCell", cellType: PokemonTableViewCell.self)) { (row, pokemon, cell) in
                cell.setup(name: pokemon.name)
            }
            .disposed(by: disposeBag)
        
        tableViewPokemon.rx.modelSelected(Pokemon.self)
            .subscribe(onNext: { [weak self] pokemon in
                let detailVC = DetailPokemonViewController()
                detailVC.pokemonURL = pokemon.url
                self?.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.syncData()
            })
            .disposed(by: disposeBag)
        
        viewModel.isSyncing
            .asDriver()
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        viewModel.isSyncing
            .asDriver()
            .drive(onNext: { [weak self] isSyncing in
                guard let self = self else { return }
                
                if isSyncing && self.viewModel.pokemons.value.isEmpty {
                    self.showHUD(progressLabel: "Mengunduh Data...")
                } else {
                    self.dismissHUD(isAnimated: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .subscribe(onNext: { [weak self] message in
                print("Error Sync: \(message)")
            })
            .disposed(by: disposeBag)
    }
}
