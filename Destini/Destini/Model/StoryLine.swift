//
//  StoryStage.swift
//  Destini
//
//  Created by Steffen André Langnes on 11/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import Foundation

class StoryLine {
    let text: String
    let actions: [StoryAction]
    
    init(text: String, actions: [StoryAction]) {
        self.text = text
        self.actions = actions
    }
}
