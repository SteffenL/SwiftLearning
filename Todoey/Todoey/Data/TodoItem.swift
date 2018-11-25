//
//  TodoItem.swift
//  Todoey
//
//  Created by Steffen André Langnes on 25/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    var category = LinkingObjects(fromType: TodoCategory.self, property: "items")
}
