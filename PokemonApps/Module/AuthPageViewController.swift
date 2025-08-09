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
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewsetup()
        // Do any additional setup after loading the view.
    }
    
    func viewsetup(){
        textfieldUsername.layer.cornerRadius = 12
        textfieldPassword.layer.cornerRadius = 12
        btnLogin.layer.cornerRadius = 14
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
        imgEye.isUserInteractionEnabled = true
        imgEye.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func togglePasswordVisibility() {
        textfieldPassword.isSecureTextEntry.toggle()
        if textfieldPassword.isSecureTextEntry {
            imgEye.image = UIImage(systemName: "eye.slash.fill")
        } else {
            imgEye.image = UIImage(systemName: "eye.fill")
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        guard let username = textfieldUsername.text, !username.isEmpty,
              let password = textfieldPassword.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Username dan password harus diisi.")
            return
        }
        
        let users = UserDefaults.standard.dictionary(forKey: "RegisteredUsers") as? [String: String] ?? [:]
        
        if users[username] == password {
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.set(username, forKey: "loggedInUser")
            let mainTabBar = DIContainer.shared.makeMainTabBarController()
            self.navigationController?.pushViewController(mainTabBar, animated: true)
        } else {
            showAlert(title: "Error", message: "Username atau password salah.")
        }
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        let vc = RegisterVc()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
