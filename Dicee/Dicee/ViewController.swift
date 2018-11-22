//
//  ViewController.swift
//  Dicee
//
//  Created by Steffen André Langnes on 16/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var diceImage1: UIImageView!
    @IBOutlet weak var diceImage2: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func rollDice() {
        let dice1 = Int.random(in: 1...6)
        let dice2 = Int.random(in: 1...6)
        diceImage1.image = UIImage(named: "dice\(dice1)")
        diceImage2.image = UIImage(named: "dice\(dice2)")
    }

    @IBAction func rollDicePressed(_ sender: UIButton) {
        rollDice()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollDice()
    }
}

