//
//  AuthPageViewController.swift
//  PokemonApps
//
//  Created by Kings on 04/08/25.
//

import UIKit

class AuthPageViewController: UIViewController {
    
    @IBOutlet weak var textfieldUsername: UITextField!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var imgEye: UIImageView!
    @IBOutlet weak var btnRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewsetup()
        // Do any additional setup after loading the view.
    }
    
    func viewsetup(){
        textfieldUsername.layer.cornerRadius = 10
        textfieldUsername.layer.borderWidth = 1.5
        textfieldUsername.layer.borderColor = UIColor.lightGray.cgColor
    }

}
