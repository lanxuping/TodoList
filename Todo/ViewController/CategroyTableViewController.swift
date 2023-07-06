//
//  CategroyTableViewController.swift
//  Todo
//
//  Created by Lan Xuping on 2023/7/5.
//

import UIKit
import CoreData
import RealmSwift

class CategroyTableViewController: SwipeTableViewController {
    var categroyArr: Results<CateM>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategroy()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textF = UITextField()
        let alertController = UIAlertController(title: "add", message: nil, preferredStyle: .alert)
        alertController.addTextField { textfield in
            textfield.translatesAutoresizingMaskIntoConstraints = false
            textfield.placeholder = "输入分类"
            textF = textfield
        }
        let alertAction = UIAlertAction(title: "确认", style: .default) { action in
            let cate = CateM()
            cate.name = textF.text!
            //在realm中无需添加数据了，数组会自动更新并监视这些数据更改 delete categroyArr.append(cate)
            self.addCategroy(cate: cate)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
        
    }
    //MARK: - coredata
    func addCategroy(cate: CateM)  {
        do {
            try realm.write({
                realm.add(cate)
            })
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadCategroy() {
        categroyArr = realm.objects(CateM.self) //从realm中获取数据
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categroyArr?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let cate = categroyArr?[indexPath.row]
        cell.textLabel?.text = cate?.name ?? "Please add categroy"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.GoToItems, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desctionVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            desctionVC.selectedCategroy = categroyArr?[indexPath.row]
        }
    }
    
    override func deleteData(with indexPath: IndexPath) {
        if let cate = categroyArr?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(cate)
                }
            } catch {
                print(error)
            }
        }
    }
}
