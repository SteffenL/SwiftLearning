//
//  CarClass.swift
//  SwiftExample
//
//  Created by Steffen André Langnes on 12/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import Foundation

enum CarType {
    case Batmobile, Fantasy
    case Boring
}

class CarClass {
    var type: CarType = .Boring

    init() {
    }

    convenience init(type: CarType) {
        self.init()
        self.type = type
    }
}
