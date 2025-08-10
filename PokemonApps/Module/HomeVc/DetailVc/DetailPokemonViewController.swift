//
//  DetailPokemonViewController.swift
//  PokemonApps
//
//  Created by Kings on 09/08/25.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class DetailPokemonViewController: UIViewController {
    
    var pokemonURL: String?
    var viewModel: ViewModelDetail!
    var pokemon: Pokemon?
    private let disposeBag = DisposeBag()
    
    private let pokemonImageView = UIImageView()
    private let nameLabel = UILabel()
    private let abilitiesLabel = UILabel()
    private let abilitiesStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        if let pokemon = pokemon {
            viewModel.fetchData(for: pokemon)
        }
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(customBackAction))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    private func setupBindings() {
        viewModel.isLoading
            .asDriver()
            .drive(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.showHUD(progressLabel: "Loading...")
                } else {
                    self?.dismissHUD(isAnimated: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.pokemonDetail
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] detail in
                guard let detail = detail else { return }
                self?.updateUI(with: detail)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        pokemonImageView.contentMode = .scaleAspectFit
        //        self.title = viewModel.pokemonName
        
        nameLabel.font = .systemFont(ofSize: 32, weight: .bold)
        nameLabel.textAlignment = .center
        abilitiesLabel.text = "Abilities"
        abilitiesLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        abilitiesLabel.textColor = .systemGray
        abilitiesLabel.textAlignment = .center
        abilitiesStackView.axis = .vertical
        abilitiesStackView.spacing = 8
        abilitiesStackView.alignment = .center
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(customBackAction))
        self.navigationItem.leftBarButtonItem = backButton
        
        let mainStack = UIStackView(arrangedSubviews: [pokemonImageView, nameLabel, abilitiesLabel, abilitiesStackView])
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    @objc private func customBackAction() {
        navigationController?.popViewController(animated: true)
    }
    
    private func updateUI(with detail: PokemonDetail) {
        self.title = detail.name
        self.nameLabel.text = detail.name
        if let urlString = detail.imageURL, let url = URL(string: urlString) {
            self.pokemonImageView.kf.setImage(with: url)
        }
        self.abilitiesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for abilityText in detail.abilities {
            let tagView = createAbilityTag(from: abilityText)
            self.abilitiesStackView.addArrangedSubview(tagView)
        }
    }
    
    private func createAbilityTag(from text: String) -> UIView {
        let tagLabel = UILabel()
        tagLabel.text = text
        tagLabel.textColor = .white
        tagLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        let tagContainer = UIView()
        tagContainer.backgroundColor = .systemBlue
        tagContainer.layer.cornerRadius = 15
        tagContainer.addSubview(tagLabel)
        
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagLabel.topAnchor.constraint(equalTo: tagContainer.topAnchor, constant: 8),
            tagLabel.bottomAnchor.constraint(equalTo: tagContainer.bottomAnchor, constant: -8),
            tagLabel.leadingAnchor.constraint(equalTo: tagContainer.leadingAnchor, constant: 16),
            tagLabel.trailingAnchor.constraint(equalTo: tagContainer.trailingAnchor, constant: -16)
        ])
        
        return tagContainer
    }
}
