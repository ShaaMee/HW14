//
//  RealmPersistance.swift
//  Homework_14
//
//  Created by user on 23.02.2021.
//

import Foundation
import RealmSwift

class ToDoList: Object {
  @objc dynamic var task: String?
  @objc dynamic var finished = false
}


class RealmPersistance {
  static let shared = RealmPersistance()
  private let realm = try! Realm()
  
  func addTaskFor(text: String) {
    let newList = ToDoList()
    newList.task = text
    try! realm.write {
      realm.add(newList)
    }
    
  }
  
  func removeTaskFor(string: String) {
    let allTasks = realm.objects(ToDoList.self)
    for object in allTasks {
      
      if object.task == string {
        try! realm.write {
          realm.delete(object)
        }
      }
      
    }
  }
  
  func getAllTasks() -> ([String], [Bool]) {
    let allTasks = realm.objects(ToDoList.self)
    var taskArray: [String] = []
    var checkmarksArray: [Bool] = []
    for task in allTasks {
      taskArray.insert(task.task ?? "", at: 0)
      checkmarksArray.insert(task.finished, at: 0)
    }
    return (taskArray, checkmarksArray)
  }
  
  
  func switchCheckmarkFor(index: Int) {
    let allTasks = realm.objects(ToDoList.self)
    try! realm .write {
      allTasks[index].finished = !allTasks[index].finished
    }
  }
  
}
