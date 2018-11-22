//
//  ViewController.swift
//  Quizzler
//
//  Created by Steffen André Langnes on 10/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var scoreLabel: UILabel!

    private let questions = QuestionRepository()
    private var questionIndex = 0
    private var score = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
    }

    @IBAction func chooseAnswer(_ sender: UIButton) {
        let answer = sender.tag == 1 ? true : false
        let question = questions.list[questionIndex]
        
        if checkAnswer(answer: answer, question: question) {
            score = min(score + question.reward, 9999)
        }
        
        moveToNextQuestion()
    }

    private func checkAnswer(answer: Bool, question: Question) -> Bool {
        return answer == question.answer
    }
    
    private func getQuestion() -> Question? {
        return questionIndex < questions.list.count ? questions.list[questionIndex] : nil
    }

    private func displayProgress() {
        let question = getQuestion()
        if question != nil {
            questionLabel.text = question!.text
        }

        scoreLabel.text = String(format: "Score: %d", score)
        progressLabel.text = String(format: "%d / %d", min(questionIndex + 1, questions.list.count), questions.list.count)
        progressBar.setProgress(Float(questionIndex) / Float(questions.list.count), animated: false)
    }

    private func moveToNextQuestion() {
        questionIndex += 1
        if questionIndex >= questions.list.count {
            displayProgress()
            endGame()
            return
        }

        displayProgress()
    }

    private func startGame() {
        resetProgress()
        moveToNextQuestion()
        displayProgress()
    }

    private func endGame() {
        let alert = UIAlertController(title: "Game Over", message: "That's all we had in store for you. It's over.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { (action) in
            self.startGame()
        }))
        present(alert, animated: true, completion: nil)
    }

    private func resetProgress() {
        score = 0
        questionIndex = -1
    }
}
