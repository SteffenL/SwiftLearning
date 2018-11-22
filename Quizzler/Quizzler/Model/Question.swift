//
//  Question.swift
//  Quizzler
//
//  Created by Steffen André Langnes on 10/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import Foundation

class Question {
    let text: String
    let answer: Bool
    let reward: Int
    
    init(text: String, answer: Bool, reward: Int) {
        self.text = text
        self.answer = answer
        self.reward = reward
    }
}
