//
//  ViewController.swift
//  Destini
//
//  Created by Steffen André Langnes on 11/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var actionButtonContainer: UIStackView!

    private var story = Story()
    private var storyStage = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
    }
    
    @objc private func chooseAction(sender: UIButton!) {
        let stage = story.getStage(id: storyStage)
        let action = stage!.actions[sender.tag]
        loadStage(id: action.target)
    }

    private func startGame() {
        loadStage(id: "start")
    }

    private func loadStage(id: String) {
        let stage = story.getStage(id: id)
        if stage == nil {
            return
        }

        storyLabel.text = stage!.text
        for view in actionButtonContainer.arrangedSubviews {
            actionButtonContainer.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        for i in 0..<stage!.actions.count {
            let action = stage!.actions[i]
            let actionButton = UIButton(type: .system)
            actionButton.tag = i
            actionButton.setTitle(action.label, for: .normal)
            actionButton.addTarget(self, action: #selector(chooseAction(sender:)), for: .touchUpInside)
            actionButtonContainer.addArrangedSubview(actionButton)
        }

        storyStage = id
    }
}
