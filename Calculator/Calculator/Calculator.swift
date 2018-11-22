//
//  Calculator.swift
//  Calculator
//
//  Created by Steffen André Langnes on 14/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import Foundation

enum CalculateOperation {
    case invalid
    case none
    case clear
    case invert
    case percent
    case divide
    case multiply
    case subtract
    case add
    case equal
    case decimalPoint
}

protocol CalculatorDelegate {
    func displayUpdated(string: String)
}

class Calculator {
    private static let symbols: [String: CalculateOperation] = [
        "C": .clear,
        "⁺⁄₋": .invert,
        "%": .percent,
        "÷": .divide,
        "×": .multiply,
        "−": .subtract,
        "+": .add,
        "=": .equal,
        ".": .decimalPoint,
        ",": .decimalPoint
    ]

    private static let operations: [CalculateOperation: (Decimal, Decimal) -> Decimal] = [
        .invalid: { previous, current in fatalError("Invalid operation") },
        .none: { (previous, current) in current },
        .clear: { (previous, current) in 0 },
        .invert: { (previous, current) in current * -1 },
        .percent: { (previous, current) in current / 100 },
        .divide: { (previous, current) in fatalError("Not implemented yet") },
        .multiply: { (previous, current) in fatalError("Not implemented yet") },
        .subtract: { (previous, current) in fatalError("Not implemented yet") },
        .add: { (previous, current) in previous + current },
        .equal: { (previous, current) in fatalError("Not implemented yet") },
        .decimalPoint: { (previous, current) in fatalError("Not implemented yet") }
    ]

    public var decimalSeparator: String {
        get {
            return Locale.current.decimalSeparator ?? "."
        }
    }

    //private var buffer: Decimal = 0
    private var previousValue: Decimal = 0
    private var currentValue: Decimal = 0 {
        didSet {
            if (currentValue != oldValue) {
                delegate?.displayUpdated(string: currentValue.description)
            }
        }
    }

    private var previousOperation: CalculateOperation = .none {
        didSet {
            if (oldValue != .none && previousOperation != oldValue) {
                applyOperation(oldValue)
            }
        }
    }

    /*private var buffer: Decimal = 0 {
        didSet {
            delegate?.displayUpdated(string: buffer.description)
        }
    }*/

    //private var history: [(o: CalculateOperation, v: Decimal)] = []


    public var delegate: CalculatorDelegate?

    func clear() {
        applyOperation(CalculateOperation.clear)
    }

    private func applyOperation(_ operation: CalculateOperation) {
        let handler = type(of: self).operations[operation]!
        currentValue = handler(previousValue, currentValue)
    }

    private func applyOperation(string operation: String) {
        let operation = type(of: self).symbols[operation] ?? .invalid
        applyOperation(operation)
    }

    func inputSymbol(_ input: String) {
        applyOperation(string: input)

        /*if operation == .add {
            intermediate += buffer
            buffer = 0
        } else if operation == .equal {

        }*/

        /*if buffers.isEmpty {
            buffers.append((o: operation, v: buffer))
        }

        buffers.append((o: operation, v: buffer))*/
    }

    func inputNumber(_ input: String) {
        currentValue = currentValue * 10 + Decimal(Int(input)!)
    }
}
