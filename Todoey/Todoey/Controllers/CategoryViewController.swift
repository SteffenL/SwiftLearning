//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Steffen André Langnes on 25/11/2018.
//  Copyright © 2018 Steffen André Langnes. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    private let realm = try! Realm()
    private var items: Results<TodoCategory>!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadItems()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCategoryItemCell", for: indexPath)
        cell.textLabel!.text = items[indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as! TodoListViewController
                controller.selectedCategory = items[indexPath.row]
            }
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField!
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "title"
            textField = alertTextField
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if !textField.text!.isEmpty {
                self.addCategory(title: textField.text!)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    private func addCategory(title: String) {
        let category = TodoCategory()
        category.title = title

        do {
            try realm.write {
                realm.add(category)
            }

            tableView.reloadData()
        } catch {
            print("Error while adding category: \(error)")
        }
    }

    private func loadItems() {
        items = realm.objects(TodoCategory.self)
        tableView.reloadData()
    }
}
