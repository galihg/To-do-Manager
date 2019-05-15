//
//  taskDetailViewController.swift
//  To-do Manager
//
//  Created by MacbookPRO on 19/04/19.
//  Copyright © 2019 CodeSuit Developer. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class TaskDetailViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var taskText: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var categoryColourTableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var completionDateTextField: UITextField!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var categoryColourButton: UIButton!
    
    var state = "add"
    
    var task: Task!
    
    var dataController:DataController!
    
    var fetchedResultController: NSFetchedResultsController<Category>!
    
    let datePicker = UIDatePicker()

    let bottomConstraintConstant = 228
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShowNotification(with:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        taskText.delegate = self
        completionDateTextField.delegate = self
        
        setUpFetchedResultController()
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(TaskDetailViewController.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(TaskDetailViewController.cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        //Add datePicker to textField
        completionDateTextField.inputView = datePicker
        
        //Add toolbar to textField
        completionDateTextField.inputAccessoryView = toolbar

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let task = task {
            taskText.text = task.name
            if let completionDate = task.completionDate {
                completionDateTextField.text = dateFormatter.string(from: completionDate)
            }
            categoryButton.setTitle(task.categoryName, for: [])
            categoryColourButton.setTitle(task.categoryColour, for: [])
        }
        
        if state == "edit" {
            self.title = "Edit Task"
        } else {
            self.title = "Add Task"
        }
        
        taskText.layer.borderWidth = 1.0
        categoryTableView.isHidden = true
        categoryColourTableView.isHidden = true
        
        if let indexPath = categoryTableView.indexPathForSelectedRow {
            categoryTableView.deselectRow(at: indexPath, animated: false)
            categoryTableView.reloadRows(at: [indexPath], with: .fade)
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        fetchedResultController = nil
    }
    
    fileprivate func setUpFetchedResultController() {
        let fetchRequest:NSFetchRequest<Category> = Category.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "categoryName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: dataController.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultController.delegate = self
        
        // Fetch
        do {
            try fetchedResultController.performFetch()
        } catch {
            print("Perform fetch error: \(error)")
        }
    }
    
    @objc func keyboardWillShowNotification(with notification: Notification) {
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else { return }

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func donedatePicker(){
        //display time
        completionDateTextField.text = dateFormatter.string(from: datePicker.date)
        
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        categoryTableView.isHidden = true
        categoryColourTableView.isHidden = true
    }
    
    func resignResponder() {
        taskText.resignFirstResponder()
        completionDateTextField.resignFirstResponder()
    }
    
    @IBAction func handleCategoryTable(_ sender: Any) {
        if categoryTableView.isHidden == true {
            categoryTableView.isHidden = false
        } else {
            categoryTableView.isHidden = true
        }
    }
    
    @IBAction func handleCategoryColourButton(_ sender: Any) {
        if categoryColourTableView.isHidden == true {
            categoryColourTableView.isHidden = false
        } else {
            categoryColourTableView.isHidden = true
        }
    }
    
    @IBAction func addTask(_ sender: Any) {
        resignResponder()
        
        if taskText.text.isEmpty == true {
            Alert.showMessage(title: "Warning", msg: "Task is empty")
        } else if completionDateTextField.text?.isEmpty == true {
            Alert.showMessage(title: "Warning", msg: "Completion date is empty")
        } else if categoryButton.titleLabel!.text == "Category" {
            Alert.showMessage(title: "Warning", msg: "You must choose category")
        } else if categoryColourButton.titleLabel!.text == "Category Colour" {
            Alert.showMessage(title: "Warning", msg: "You must choose category's colour")
        }
        
        guard let name = taskText.text, let completionDate = completionDateTextField.text, let categoryName = categoryButton.titleLabel?.text, let categoryColour = categoryColourButton.titleLabel?.text, !name.isEmpty, !completionDate.isEmpty, categoryName != "Category", categoryColour != "Category Colour" else {
            return
        }
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatter.date(from:completionDate)!
        
        if let task = self.task {
            task.name = name
            task.completionDate = date
            //task.category?.name = categoryName
            //task.category?.colour = categoryColour
            
            task.categoryName = categoryName
            task.categoryColour = categoryColour
        } else {
            let task = Task(context: dataController.viewContext)
            task.name = name
            task.completionDate = date
            task.hasCompleted = false
            task.categoryName = categoryName
            task.categoryColour = categoryColour
            //category.categoryName = categoryName
            //category.colour = categoryColour
            //task.category = category
        }
    
        do {
            try dataController.viewContext.save()
            Alert.showMessage(title: "Success!", msg: "Task has been successfully saved")
        } catch {
            Alert.showMessage(title: "Failure", msg: "Failed to save task")
            print("Error saving task: \(error)")
        }
        
        SetNotification.toggleNotification(title: name, date: date, subtitle: "You have task to complete: ")
    }
    
}

extension TaskDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == categoryTableView {
            return fetchedResultController.sections?[section].numberOfObjects ?? 0
        } else {
            return colourArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == categoryTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
            // Configure the cell...
            let category = fetchedResultController.object(at: indexPath)
            cell.textLabel?.text = category.categoryName
           
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryColourCell", for: indexPath)
            cell.textLabel?.text = colourArray[indexPath.row]
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == categoryTableView {
            let category = fetchedResultController.object(at: indexPath)
            let categoryName = category.categoryName
            categoryTableView.deselectRow(at: indexPath, animated: true)
            categoryTableView.isHidden = true
            categoryButton.setTitle(categoryName, for: [])
        } else if tableView == categoryColourTableView {
            categoryColourTableView.deselectRow(at: indexPath, animated: true)
            categoryColourTableView.isHidden = true
            categoryColourButton.setTitle(colourArray[indexPath.row], for: [])
        }
    }

}

extension TaskDetailViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        categoryTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        categoryTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: categoryTableView.insertSections(indexSet, with: .fade)
        case .delete: categoryTableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            categoryTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            categoryTableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            /*if let indexPath = indexPath, let cell = categoryTableView.cellForRow(at: indexPath) {
                //let category = fetchedResultController.object(at: indexPath)
                //cell.textLabel?.text = category.categoryName
                
            }*/
            categoryTableView.reloadRows(at: [indexPath!], with: .fade)
        default:
            break
        }
    }
}

