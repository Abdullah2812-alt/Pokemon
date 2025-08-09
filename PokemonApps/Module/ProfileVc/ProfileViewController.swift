//
//  ProfileViewController.swift
//  PokemonApps
//
//  Created by Kings on 06/08/25.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblInitial: UILabel!
    @IBOutlet weak var bgInitial: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewsetup()
    }
    
    func viewsetup(){
        bgInitial.layer.cornerRadius = bgInitial.frame.width / 2
    }
    
    func loadUserData() {
        if let username = UserDefaults.standard.string(forKey: "loggedInUser") {
            lblUsername.text = username
            if let firstChar = username.first {
                lblInitial.text = String(firstChar).uppercased()
            }
        }
    }
}
