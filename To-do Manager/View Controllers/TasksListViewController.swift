//
//  ViewController.swift
//  To-do Manager
//
//  Created by MacbookPRO on 19/04/19.
//  Copyright © 2019 CodeSuit Developer. All rights reserved.
//

import UIKit
import CoreData

class TasksListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataController: DataController!
    
    var listDataSource:ListDataSource<Task, TaskCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "What to do"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpFetchedResultsController()
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
       
        listDataSource = nil
    }
    
    fileprivate func setUpFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Task> = Task.fetchRequest()
        let predicate = NSPredicate(format: "hasCompleted == %@", NSNumber(value: false))
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "completionDate", ascending: true)]
        
        listDataSource = ListDataSource(tableView: tableView, managedObjectContext: dataController.viewContext, fetchRequest: fetchRequest, configure: { (taskCell, task) in
            taskCell.taskName.text = task.name
            taskCell.categoryName.text = task.categoryName
            
            //using checkbox
            /*
            taskCell.checkBox.tag = index.row
            taskCell.checkBox.setOn(task.hasCompleted, animated: false)
            //taskCell.checkBox.setOn(self.selectedRows.contains(index.row), animated: false)
            taskCell.checkBox.checkboxValueChangedBlock = {
                isOn in
            
                if isOn == true {
                    self.tableView.reloadData()
                    self.listDataSource.complete(at: index)
                } else {
                    return
                }
            }*/
            
            if let textColour = task.categoryColour {
                switch textColour {
                case "Red" : taskCell.categoryName.textColor = UIColor(named: "Red")
                case "Yellow" : taskCell.categoryName.textColor = UIColor(named: "Yellow")
                case "Blue" : taskCell.categoryName.textColor = UIColor(named: "Blue")
                case "Green" : taskCell.categoryName.textColor = UIColor(named: "Green")
                case "Brown" : taskCell.categoryName.textColor = UIColor(named: "Brown")
                default:
                    taskCell.categoryName.textColor = UIColor(named: "Black")
                }
            }
            
            if let completionDate = task.completionDate {
                taskCell.completionDate.text = dateFormatter.string(from: completionDate)
            }
        })
        
        tableView.dataSource = listDataSource
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TaskDetailViewController {
            vc.dataController = dataController
            if segue.identifier == "showTaskDetail"{
                if let indexPath = tableView.indexPathForSelectedRow {
                    vc.state = "edit"
                    vc.task = listDataSource.fetchedResultController.object(at: indexPath)
                }
            }
        } else if let vc  = segue.destination as? SettingViewController {
            vc.dataController = dataController
        } else if let vc  = segue.destination as? CompletedTaskListsViewController {
            vc.dataController = dataController
        }
    }
    
}

extension TasksListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .destructive, title: "Complete") { (action, view, handler) in
            self.tableView.reloadData()
            self.listDataSource.complete(at: indexPath)
        }
        deleteAction.backgroundColor = .green
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
}




