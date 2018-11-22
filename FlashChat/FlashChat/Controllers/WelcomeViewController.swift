//
//  WelcomeViewController.swift
//  FlashChat
//
//  Created by Steffen André Langnes on 17/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if let user = Auth.auth().currentUser {
            print("Firebase user: \(user.uid)")
            performSegue(withIdentifier: "showChat", sender: self)
        }
    }

}

