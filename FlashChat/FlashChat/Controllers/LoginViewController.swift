//
//  LoginViewController.swift
//  FlashChat
//
//  Created by Steffen André Langnes on 17/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, KeyboardHelperDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    private var keyboardHelper: KeyboardHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardHelper = KeyboardHelper(view: view, constraint: bottomLayoutConstraint)
        keyboardHelper!.delegate = self
    }

    func kbhTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.returnKeyType {
        case .next:
            if textField == emailTextField! {
                passwordTextField.becomeFirstResponder()
            }
        case .done:
            logIn()
        default:
            return true
        }

        return false
    }

    private func logIn() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("E-mail and password is required")
            return
        }

        emailTextField.isEnabled = false
        passwordTextField.isEnabled = false
        activityIndicatorView.startAnimating()

        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            self.emailTextField.isEnabled = true
            self.passwordTextField.isEnabled = true
            self.activityIndicatorView.stopAnimating()

            if let err = error {
                print(err)
                return
            }

            self.performSegue(withIdentifier: "showChat", sender: self)
        }
    }
}

