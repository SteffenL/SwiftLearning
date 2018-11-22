//
//  ViewController.swift
//  Calculator
//
//  Created by Steffen André Langnes on 14/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CalculatorDelegate {
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var decimalSeparatorButton: UIButton!
    
    private let calculator = Calculator()

    override func viewDidLoad() {
        super.viewDidLoad()
        decimalSeparatorButton.setTitle(calculator.decimalSeparator, for: .normal)
        calculator.delegate = self
        calculator.clear()
    }

    @IBAction func operationPressed(_ sender: UIButton) {
        calculator.inputSymbol(sender.currentTitle!)
    }

    @IBAction func numberPressed(_ sender: UIButton) {
        calculator.inputNumber(sender.currentTitle!)
    }

    func displayUpdated(string: String) {
        displayLabel.text = string
    }
}

