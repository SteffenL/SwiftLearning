//
//  TemperatureConverter.swift
//  Clima
//
//  Created by Steffen André Langnes on 12/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import Foundation

enum TemperatureUnit {
    case celsius
    case kelvin
}

class TemperatureConverter {
    static private let converters: [TemperatureUnit: [TemperatureUnit: (Double) -> Double]] = [
        .celsius: [
            .kelvin: { value -> Double in return value + 273.15 }
        ],
        .kelvin: [
            .celsius: { value -> Double in return value - 273.15 }
        ]
    ]

    static func convert(_ value: Double, from: TemperatureUnit, to: TemperatureUnit) -> Double {
        return self.converters[from]![to]!(value)
    }
}
