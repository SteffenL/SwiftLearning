//
//  QuestionRepository.swift
//  Quizzler
//
//  Created by Steffen André Langnes on 10/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import Foundation

class QuestionRepository {
    var list = [Question]()
    
    init() {
        let questions = [
            Question(text: "Question 1", answer: true, reward: 10),
            Question(text: "Question 2", answer: false, reward: 20),
            Question(text: "Question 3", answer: false, reward: 30),
            Question(text: "Question 4", answer: true, reward: 40)
        ]

        for question in questions {
            self.list.append(question)
        }
    }
}
