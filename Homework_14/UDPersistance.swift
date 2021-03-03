//
//  UDPersistance.swift
//  Homework_14
//
//  Created by user on 22.02.2021.
//

import Foundation

class UDPersistance {
  static let shared = UDPersistance()
  
  private let kNameKey = "UDPersistance.kNameKey"
  private let kSurnameKey = "UDPersistance.kSurnameKey"
  
  var name: String {
    set { UserDefaults.standard.setValue(newValue, forKey: kNameKey)}
    get { return UserDefaults.standard.string(forKey: kNameKey) ?? "" }
  }
  
  var surename: String {
    set { UserDefaults.standard.setValue(newValue, forKey: kSurnameKey)}
    get { return UserDefaults.standard.string(forKey: kSurnameKey) ?? "" }
  }
}
