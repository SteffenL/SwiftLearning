//
//  main.swift
//  SwiftExample
//
//  Created by Steffen André Langnes on 12/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import Foundation

let car1 = CarClass(type: .Fantasy)
print(car1.type)

let car2: Car = SelfDrivingCar()
car2.drive()
