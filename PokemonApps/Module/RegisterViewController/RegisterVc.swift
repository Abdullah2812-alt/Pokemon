//
//  RegisterVc.swift
//  PokemonApps
//
//  Created by Kings on 05/08/25.
//

import UIKit

class RegisterVc: UIViewController {
    
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPass: UITextField!
    @IBOutlet weak var textFieldConfirmPass: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewsetup()
        // Do any additional setup after loading the view.
    }
    
    func viewsetup(){
        btnRegister.layer.cornerRadius = 15
        btnRegister.layer.masksToBounds = true
    }

    @IBAction func RegisterPressed(_ sender: Any) {
        guard let username = textFieldUsername.text, !username.isEmpty,
              let password = textFieldPass.text, !password.isEmpty,
              let confirmPassword = textFieldConfirmPass.text, !confirmPassword.isEmpty else {
            showAlert(title: "Error", message: "Semua field harus diisi.")
            return
        }
        
        guard password == confirmPassword else {
            showAlert(title: "Error", message: "Password dan Konfirmasi Password tidak cocok.")
            return
        }
        
        var users = UserDefaults.standard.dictionary(forKey: "RegisteredUsers") as? [String: String] ?? [:]
        
        if users[username] != nil {
            showAlert(title: "Error", message: "Username sudah terdaftar. Silakan gunakan username lain.")
            return
        }
        users[username] = password
        UserDefaults.standard.set(users, forKey: "RegisteredUsers")
        showAlertAndPop(title: "Berhasil", message: "Registrasi berhasil. Silakan login.")
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertAndPop(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
}
