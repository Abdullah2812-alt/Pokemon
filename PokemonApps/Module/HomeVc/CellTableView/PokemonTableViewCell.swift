//
//  PokemonTableViewCell.swift
//  PokemonApps
//
//  Created by Kings on 09/08/25.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblPokemon: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(name: String) {
        lblPokemon.text = name.capitalized
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
          
          self.selectionStyle = .none
          
      }
      
      required init?(coder: NSCoder) {
          super.init(coder: coder)
          
          self.selectionStyle = .none
      }
}
