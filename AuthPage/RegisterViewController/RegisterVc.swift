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
    @IBOutlet weak var buttonRegister: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewsetup()
        // Do any additional setup after loading the view.
    }
    
    func viewsetup(){
        buttonRegister.layer.cornerRadius = 15
    }

    @IBAction func RegisterPressed(_ sender: Any) {
        // Ambil teks dari field
        guard let username = textFieldUsername.text, !username.isEmpty,
              let password = textFieldPass.text, !password.isEmpty,
              let confirmPassword = textFieldConfirmPass.text, !confirmPassword.isEmpty else {
            // Tampilkan alert jika ada field yang kosong
            showAlert(title: "Error", message: "Semua field harus diisi.")
            return
        }
        
        // Cek jika password dan konfirmasi password cocok
        guard password == confirmPassword else {
            showAlert(title: "Error", message: "Password dan Konfirmasi Password tidak cocok.")
            return
        }
        
        // Simpan data pengguna ke UserDefaults
        // Menggunakan array untuk menyimpan beberapa pengguna.
        var users = UserDefaults.standard.dictionary(forKey: "RegisteredUsers") as? [String: String] ?? [:]
        
        // Cek apakah username sudah terdaftar
        if users[username] != nil {
            showAlert(title: "Error", message: "Username sudah terdaftar. Silakan gunakan username lain.")
            return
        }
        
        // Tambahkan user baru
        users[username] = password
        UserDefaults.standard.set(users, forKey: "RegisteredUsers")
        
        // Tampilkan alert berhasil dan kembali ke halaman login
        showAlertAndPop(title: "Berhasil", message: "Registrasi berhasil. Silakan login.")
        
    }
    
    // Fungsi untuk menampilkan alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Fungsi untuk menampilkan alert dan kembali ke halaman sebelumnya (AuthPageViewController)
    func showAlertAndPop(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
}
