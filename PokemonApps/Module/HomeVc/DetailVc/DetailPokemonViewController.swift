//
//  DetailPokemonViewController.swift
//  PokemonApps
//
//  Created by Kings on 09/08/25.
//

import UIKit
import Kingfisher

class DetailPokemonViewController: UIViewController {
    
    var pokemonURL: String?
    private var viewModel = ViewModelDetail()
    
    private let pokemonImageView = UIImageView()
    private let nameLabel = UILabel()
    private let abilitiesLabel = UILabel()
    private let abilitiesStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModelBinding()
        
        if let url = pokemonURL {
            showHUD(progressLabel: "Loading Details...")
            viewModel.requestData(for: url)
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
    
    @objc private func customBackAction() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupViewModelBinding() {
        viewModel.onDataUpdate = { [weak self] in
            self?.dismissHUD(isAnimated: true)
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        
        viewModel.onError = { [weak self] error in
            self?.dismissHUD(isAnimated: true)
            print("Error fetching detail: \(error.localizedDescription)")
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        pokemonImageView.contentMode = .scaleAspectFit
        self.title = viewModel.pokemonName
        
        nameLabel.font = .systemFont(ofSize: 32, weight: .bold)
        nameLabel.textAlignment = .center
        
        abilitiesLabel.text = "Abilities"
        abilitiesLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        abilitiesLabel.textColor = .systemGray
        abilitiesLabel.textAlignment = .center
        
        abilitiesStackView.axis = .vertical
        abilitiesStackView.spacing = 8
        abilitiesStackView.alignment = .center
        
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
    
    private func updateUI() {
        self.title = viewModel.pokemonName
        nameLabel.text = viewModel.pokemonName
        
        if let urlString = viewModel.imageURL, let url = URL(string: urlString) {
            pokemonImageView.kf.setImage(with: url)
        }
        abilitiesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for abilityText in viewModel.pokemonAbilities {
            let tagView = createAbilityTag(from: abilityText)
            abilitiesStackView.addArrangedSubview(tagView)
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
