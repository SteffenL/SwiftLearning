//
//  TodoListViewController
//  Todoey
//
//  Created by Steffen André Langnes on 17/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController, UISearchBarDelegate {
    private var items = [TodoItem]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
        item.done = !item.done
        cell.accessoryType = item.done ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)

        self.saveItems()
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

            self.addItem(title: title)
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    private func getItemsDataURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Items.plist")
    }

    private func addItem(title: String) {
        let item = TodoItem(context: context)
        item.title = title
        item.done = false
        item.category = self.selectedCategory!

        self.items.append(item)
        self.saveItems()
        self.tableView.reloadData()
    }

    private func loadItems(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "category = %@", selectedCategory!)
        if let predicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate
        }

        do {
            items = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print(error)
        }
    }

    private func search(_ text: String = "") {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        if text.isEmpty {
            loadItems()
        } else {
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            loadItems(with: request, predicate: predicate)
        }
    }

    private func saveItems() {
        do {
            try context.save()
        } catch {
            print(error)
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
