//
//  TodoListViewController
//  Todoey
//
//  Created by Steffen André Langnes on 17/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import UIKit

class TodoItem: Codable {
    var title: String = ""
    var done: Bool = false

    init() {
    }

    convenience init(title: String, done: Bool) {
        self.init()
        self.title = title
        self.done = done
    }
}

class TodoListViewController: UITableViewController {
    let userDefaults = UserDefaults.standard
    var items = [TodoItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        items = loadItems()
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

        self.saveItems(items: self.items)
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
            self.saveItems(items: self.items)
            self.tableView.reloadData()
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    private func getItemsDataURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Items.plist")
    }

    private func loadItems() -> [TodoItem] {
        do {
            let data = try Data(contentsOf: getItemsDataURL())
            let decoder = PropertyListDecoder()
            let items = try decoder.decode([TodoItem].self, from: data)
            return items
        } catch {
            print(error)
            return []
        }
    }

    private func saveItems(items: [TodoItem]) {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: getItemsDataURL())
        } catch {
            print(error)
        }
    }
}
