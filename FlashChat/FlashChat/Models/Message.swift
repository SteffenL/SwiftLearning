//
//  Message.swift
//  FlashChat
//
//  Created by Steffen André Langnes on 18/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import Foundation

struct Message {
    let sender: String
    let body: String

    init(sender: String, body: String) {
        self.sender = sender
        self.body = body
    }
}
