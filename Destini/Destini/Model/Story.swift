//
//  Story.swift
//  Destini
//
//  Created by Steffen André Langnes on 11/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import Foundation

class Story {
    private let stages: [String:StoryLine] = [
        "start": StoryLine(text: "The following story is fictional.", actions: [
            StoryAction(target: "a1", label: "Begin")
        ]),
        "a1": StoryLine(text: "You wake on a Saturday night. Horses are riding on dolphins that swim on glittering rainbows.", actions: [
            StoryAction(target: "a2", label: "Chase the dolphins"),
            StoryAction(target: "a3", label: "Envy their happiness")
        ]),
        "a2": StoryLine(text: "Cats join the chase and everyone enjoys this happy moment!", actions: [
            StoryAction(target: "b1", label: "Pinch your arm"),
        ]),
        "a3": StoryLine(text: "Cats join the chase and everyone enjoys this happy moment—except you.", actions: [
            StoryAction(target: "b1", label: "Pinch your arm")
        ]),
        "b1": StoryLine(text: "As you wake from the strangest dream a Monday morning, a flake of snow lands on your forehead. The window has been open all night. You have to go to work.", actions: [
            StoryAction(target: "b2", label: "Perform morning ritual")
        ]),
        "b2": StoryLine(text: "As you muster the courage to prepare for work, you are discouraged by a chilling gust of wind.", actions: [
            StoryAction(target: "b3", label: "Close window")
        ]),
        "b3": StoryLine(text: "You quickly closed the window and hopped back into bed.", actions: [
            StoryAction(target: "b7", label: "Perform morning ritual"),
            StoryAction(target: "b4", label: "Sleep 5 more minutes")
        ]),
        "b4": StoryLine(text: "You wake up 20 minutes later. There is still time as you usually wake up early.", actions: [
            StoryAction(target: "b7", label: "Perform morning ritual"),
            StoryAction(target: "b5", label: "Lie down again")
        ]),
        "b5": StoryLine(text: "You wake up 30 minutes later.", actions: [
            StoryAction(target: "b6", label: "Perform morning ritual")
        ]),
        "b6": StoryLine(text: "With mostly everything prepared, a shameful day lies ahead at the office.", actions: []),
        "b7": StoryLine(text: "With everything prepared, a new exciting day lies ahead at the office.", actions: [])
    ]

    func getStage(id: String) -> StoryLine {
        return stages[id]!
    }
}
