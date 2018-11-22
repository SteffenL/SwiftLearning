//
//  ChangeCityViewController.swift
//  Clima
//
//  Created by Steffen André Langnes on 13/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func cityWasChanged(city: String)
}

class ChangeCityViewController: UIViewController {
    @IBOutlet weak var cityTextField: UITextField!

    var delegate: ChangeCityDelegate?

    var city: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        cityTextField.text = city
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func applyPressed(_ sender: UIButton) {
        delegate?.cityWasChanged(city: cityTextField.text!)
        dismiss(animated: true, completion: nil)
    }
}
