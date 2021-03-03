//
//  CoreDataTableViewController.swift
//  Homework_14
//
//  Created by user on 23.02.2021.
//

import UIKit
import CoreData

class CoreDataTableViewController: UITableViewController {
  
  var allTasksCoreData: [CoreDataList] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let context = getContext()
    let fetchRequest: NSFetchRequest<CoreDataList> = CoreDataList.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: "task", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    do {
      allTasksCoreData = try context.fetch(fetchRequest)
    } catch let error as NSError{
      print(error.localizedDescription)
    }
    
  }
  
  @IBAction func addTaskButton(_ sender: UIBarButtonItem) {
    let alertController = UIAlertController(title: "Добавить новую задачу", message: "Введите новую задачу", preferredStyle: .alert)
    
    
    let saveAction = UIAlertAction(title: "Добавить", style: .default) { action in
      let textField = alertController.textFields?.first
      if let newTask = textField?.text {
        self.addTask(withText: newTask)
        self.tableView.reloadData()
      }
    }
    
    let cancelAction = UIAlertAction(title: "Отмена", style: .default) { _ in }
    
    alertController.addTextField { _ in }
    alertController.addAction(saveAction)
    alertController.addAction(cancelAction)
    present(alertController, animated: true, completion: nil)
  }
  
  private func getContext() -> NSManagedObjectContext {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    return context
  }
  
  private func addTask(withText text: String) {
    let context = getContext()
      
    guard let entity = NSEntityDescription.entity(forEntityName: "CoreDataList", in: context) else { return }
    
    let listObject = CoreDataList(entity: entity, insertInto: context)
    listObject.task = text
    listObject.finished = false
    
    do {
      try context.save()
      allTasksCoreData.insert(listObject, at: 0)
    } catch let error as NSError {
      print(error.localizedDescription)
    }
    
  }
  
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return allTasksCoreData.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "coreDataCell", for: indexPath)
    cell.textLabel?.text = allTasksCoreData[indexPath.row].task
    cell.accessoryType = allTasksCoreData[indexPath.row].finished ? .checkmark : .none
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    if editingStyle == .delete {
      let context = getContext()
      let fetchRequest: NSFetchRequest<CoreDataList> = CoreDataList.fetchRequest()
      let sortDescriptor = NSSortDescriptor(key: "task", ascending: false)
      fetchRequest.sortDescriptors = [sortDescriptor]
      
      if let result = try? context.fetch(fetchRequest) {
        let removeTask = result[indexPath.row]
        context.delete(removeTask)
        allTasksCoreData.remove(at: indexPath.row)
        do {
          try context.save()
        } catch let error as NSError {
          print(error.localizedDescription)
        }
        
      }

      tableView.reloadData()
    }
    
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let context = getContext()
    let fetchRequest: NSFetchRequest<CoreDataList> = CoreDataList.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: "task", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    if let result = try? context.fetch(fetchRequest) {
      result[indexPath.row].setValue(!allTasksCoreData[indexPath.row].finished, forKey: "finished")
    }
    
    do {
      try context.save()
    } catch let error as NSError {
      print(error.localizedDescription)
    }
    tableView.reloadData()
    
  }

}
