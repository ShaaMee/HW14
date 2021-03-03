//
//  ViewController.swift
//  Homework_14
//
//  Created by user on 22.02.2021.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var surnameTextField: UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    nameTextField.text = UDPersistance.shared.name
    surnameTextField.text = UDPersistance.shared.surename

  }

  @IBAction func saveButton(_ sender: UIButton) {
    UDPersistance.shared.name = nameTextField.text ?? ""
    UDPersistance.shared.surename = surnameTextField.text ?? ""
    
    let alertController = UIAlertController(title: "Изменение полей", message: "Изменения фамилии и имени сохранены.", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)

  }
  
}

