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
        textfieldUsername.layer.cornerRadius = 10
        textfieldUsername.layer.borderWidth = 1.5
        textfieldUsername.layer.borderColor = UIColor.lightGray.cgColor
        textfieldPassword.layer.cornerRadius = 10
        textfieldPassword.layer.borderWidth = 1.5
        textfieldPassword.layer.borderColor = UIColor.lightGray.cgColor
        btnLogin.layer.cornerRadius = 14
        
        // Tambahkan gesture recognizer untuk menyembunyikan/menampilkan password
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
        imgEye.isUserInteractionEnabled = true
        imgEye.addGestureRecognizer(tapGestureRecognizer)
//        textfieldPassword.isSecureTextEntry = true
    }
    
    
    // Fungsi untuk menyembunyikan/menampilkan password
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
        
        // Ambil data pengguna dari UserDefaults
        let users = UserDefaults.standard.dictionary(forKey: "RegisteredUsers") as? [String: String] ?? [:]
        
        // Cek apakah username terdaftar dan password cocok
        if users[username] == password {
            // Login berhasil
            // Simpan status login
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.set(username, forKey: "loggedInUser")
            
            // Navigasi ke halaman utama (TabbarVc)
            let vc = TabbarVc()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            // Login gagal
            showAlert(title: "Error", message: "Username atau password salah.")
        }
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        // Navigasi ke halaman registrasi
        let vc = RegisterVc()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // Fungsi untuk menampilkan alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
