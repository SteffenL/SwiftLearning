//
//  TodoListViewController
//  Todoey
//
//  Created by Steffen André Langnes on 17/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import UIKit

class TodoItem {
    var title: String = ""
    var done: Bool = false

    init(title: String, done: Bool) {
        self.title = title
        self.done = done
    }
}

class TodoListViewController: UITableViewController {
    let userDefaults = UserDefaults.standard
    var items = [TodoItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let savedItems = userDefaults.array(forKey: "TodoItems") {
            self.items = savedItems.map { (savedItem) -> TodoItem? in
                if let dict = savedItem as? Dictionary<String, Any> {
                    let title = dict["Title"] as! String
                    let done = dict["Done"] as! Bool
                    return TodoItem(title: title, done: done)
                }

                return nil
            }.filter { (item) -> Bool in return item != nil }.map { item in item! }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let viewModel = items[indexPath.row]
        cell.textLabel?.text = viewModel.title
        cell.accessoryType = viewModel.done ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        let item = items[indexPath.row]
        item.done = !item.done
        cell.accessoryType = item.done ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)

        self.userDefaults.set(self.items.map { item -> [String: Any] in
            return [
                "Title": item.title,
                "Done": item.done
            ]
        }, forKey: "TodoItems")
        self.userDefaults.synchronize()
    }

    @IBAction func addItemPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        var descriptionTextField: UITextField?

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "description"
            descriptionTextField = alertTextField
        }

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let title = descriptionTextField!.text!
            if title.isEmpty {
                return
            }

            self.items.append(TodoItem(title: title, done: false))
            self.userDefaults.set(self.items.map { item -> [String: Any] in
                return [
                    "Title": item.title,
                    "Done": item.done
                ]
            }, forKey: "TodoItems")
            self.userDefaults.synchronize()
            self.tableView.reloadData()
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
