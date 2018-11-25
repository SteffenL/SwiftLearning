//
//  TodoCategory.swift
//  Todoey
//
//  Created by Steffen André Langnes on 25/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import Foundation
import RealmSwift

class TodoCategory: Object {
    @objc dynamic var title: String = ""
    let items = List<TodoItem>()
}
