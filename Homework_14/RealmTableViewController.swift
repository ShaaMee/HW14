//
//  RealmTableViewController.swift
//  Homework_14
//
//  Created by user on 23.02.2021.
//

import UIKit

class RealmTableViewController: UITableViewController {
  
  var allTasks: [String] = RealmPersistance.shared.getAllTasks().0
  var cellsSelected: [Bool] = RealmPersistance.shared.getAllTasks().1
  
  override func viewDidLoad() {
    super.viewDidLoad()

    
  }
  
  @IBAction func addTaskButton(_ sender: UIBarButtonItem) {
    let alertController = UIAlertController(title: "Добавить новую задачу", message: "Введите новую задачу", preferredStyle: .alert)
    
    
    let saveAction = UIAlertAction(title: "Добавить", style: .default) { action in
      let textField = alertController.textFields?.first
      if let newTask = textField?.text {
        self.allTasks.insert(newTask, at: 0)
        self.cellsSelected.insert(false, at: 0)
        RealmPersistance.shared.addTaskFor(text: newTask)
        self.tableView.reloadData()
      }
    }
    
    let cancelAction = UIAlertAction(title: "Отмена", style: .default) { _ in }
    
    alertController.addTextField { _ in }
    alertController.addAction(saveAction)
    alertController.addAction(cancelAction)
    present(alertController, animated: true, completion: nil)
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return allTasks.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "realmCell", for: indexPath)
    cell.textLabel?.text = allTasks[indexPath.row]
    cell.accessoryType = cellsSelected[indexPath.row] ? .checkmark : .none
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    if editingStyle == .delete {
      RealmPersistance.shared.removeTaskFor(string: allTasks[indexPath.row])
      allTasks.remove(at: indexPath.row)
      cellsSelected.remove(at: indexPath.row)
      tableView.reloadData()
    }
    
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    cellsSelected[indexPath.row] = !cellsSelected[indexPath.row]
    RealmPersistance.shared.switchCheckmarkFor(index: (cellsSelected.count - 1 - indexPath.row))
    tableView.reloadData()
  }
  
}
