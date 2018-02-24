//
//  ViewController.swift
//  Todoey
//
//  Created by Jacob Boudreau on 2/8/18.
//  Copyright © 2018 Jacob Boudreau. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [ToDoItem]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        loadItems()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = item.item
        
        cell.accessoryType = item.checked ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
       
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveItems()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Create new item"
            alertTextField=textField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if alertTextField.text != nil {
                
                let newItem = ToDoItem()
                newItem.item = alertTextField.text!
                self.itemArray.append(newItem)

                self.saveItems()
            }
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding array \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([ToDoItem].self, from: data)
            } catch {
                print("Error decoding array \(error)")
            }
        }
        
    }
    
}

