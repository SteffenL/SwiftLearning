//
//  ViewController.swift
//  SwiftDependApp
//
//  Created by Steffen André Langnes on 26/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import UIKit
import SwiftDependKit

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = SwiftDependKit.hello
    }


}

