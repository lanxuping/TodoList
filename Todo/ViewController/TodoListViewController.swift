//
//  ViewController.swift
//  Todo
//
//  Created by Lan Xuping on 2023/7/4.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    let realm = try! Realm()
    var itemArray: Results<Item>?
    var userDefault = UserDefaults.standard
    var selectedCategroy: CateM? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func click(_ sender: UIBarButtonItem) {
        var textF = UITextField()
        let alert = UIAlertController(title: "add", message: "new", preferredStyle: .alert)
        let action = UIAlertAction(title: "add item", style: .default) { ac in
            if let currentCateM = self.selectedCategroy {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textF.text!
                        newItem.dataCreated = Date.now
                        currentCateM.items.append(newItem)
                    }
                } catch {
                    print(error)
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { textField in
            textF = textField
            textField.placeholder = "normal"
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "no items"
        }
        return cell
    }
    override func deleteData(with indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print(error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write({
                    item.done = !item.done //更新数据  &  删除数据：realm.delete(item)
                })
            } catch {
                print(error)
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func loadItems() {
        itemArray = selectedCategroy?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray = itemArray?.filter("title CONTAINS[CD] %@", searchBar.text!).sorted(byKeyPath: "dataCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}






//MARK: - NSCoder filemanager (plist)
/*
let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
func loadItems(){
    do {
        if let data = try? Data(contentsOf: filePath!) {
            let decoder = PropertyListDecoder()
            itemArray = try decoder.decode([Item].self, from: data)
        }
    } catch {
        print(error)
    }
}
func saveItems() {
        let decode = PropertyListEncoder()
        do {
            let data = try decode.encode(itemArray)
            try data.write(to: filePath!)
        } catch {
            print(error)
        }
}
*/
