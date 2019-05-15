//
//  AddCategoryViewController.swift
//  To-do Manager
//
//  Created by MacbookPRO on 20/04/19.
//  Copyright © 2019 CodeSuit Developer. All rights reserved.
//

let colourArray = ["Red", "Blue", "Yellow", "Green", "Brown"]

import UIKit

class AddCategoryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var categoryNameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryColourButton: UIButton!
    
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShowNotification(with:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        categoryNameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Add Category"
        tableView.isHidden = true
    }
    
    @objc func keyboardWillShowNotification(with notification: Notification) {
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else { return }

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        tableView.isHidden = true
    }
    
    @IBAction func categoryColourButton(_ sender: Any) {
        if tableView.isHidden == true {
            tableView.isHidden = false
        } else {
            tableView.isHidden = true
        }
    }
    
    @IBAction func addCategory(_ sender: Any) {
        guard let categoryName = categoryNameTextField.text, let categoryColour = categoryColourButton.titleLabel?.text, !categoryName.isEmpty, categoryColour != "Category Colour" else {
            return
        }
        
        let category = Category(context: dataController.viewContext)
        category.categoryName = categoryName
        category.colour = categoryColour
        
        do {
            try dataController.viewContext.save()
            categoryNameTextField.resignFirstResponder()
            Alert.showMessage(title: "Success!", msg: "Category has been successfully saved ")
        } catch {
            print("Error saving category: \(error)")
        }
    }
    
}

extension AddCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colourArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingColourCell", for: indexPath)
        cell.textLabel?.text = colourArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isHidden = true
        categoryColourButton.setTitle(colourArray[indexPath.row], for: [])
    }
    
    
}

