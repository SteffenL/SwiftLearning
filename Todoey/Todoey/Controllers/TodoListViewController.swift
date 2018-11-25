//
//  TodoListViewController
//  Todoey
//
//  Created by Steffen André Langnes on 17/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController, UISearchBarDelegate {
    private let realm = try! Realm()
    private var items: Results<TodoItem>!
    var selectedCategory: TodoCategory?

    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
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

        do {
            try realm.write {
                item.done = !item.done
            }
        } catch {
            print("Error while saving done status: \(error)")
        }

        cell.accessoryType = item.done ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addItemPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        var descriptionTextField: UITextField?

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "title"
            descriptionTextField = alertTextField
        }

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let title = descriptionTextField!.text!
            if title.isEmpty {
                return
            }

            self.addItem(title: title)
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    private func getItemsDataURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Items.plist")
    }

    private func addItem(title: String) {
        do {
            try realm.write {
                let item = TodoItem()
                item.title = title
                selectedCategory!.items.append(item)
            }

            self.tableView.reloadData()
        } catch {
            print("Error while saving item: \(error)")
        }
    }

    private func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

    private func search(_ text: String = "") {
        if text.isEmpty {
            loadItems()
        } else {
            items = selectedCategory?.items
                .filter("title CONTAINS[cd] %@", searchBar.text!)
                .sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        loadItems()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(searchBar.text!)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        UIView.animate(withDuration: 0.1) {
            searchBar.layoutIfNeeded()
        }
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        UIView.animate(withDuration: 0.1) {
            searchBar.layoutIfNeeded()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText)
    }
}
