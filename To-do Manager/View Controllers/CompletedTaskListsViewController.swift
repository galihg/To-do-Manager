//
//  completedTaskListsViewController.swift
//  To-do Manager
//
//  Created by MacbookPRO on 19/04/19.
//  Copyright © 2019 CodeSuit Developer. All rights reserved.
//

import UIKit
import CoreData

class CompletedTaskListsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataController: DataController!
    
    var listDataSource:ListDataSource<Task, CompletedTaskCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        listDataSource = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Completed Tasks"
        setUpFetchedResultsController()
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    fileprivate func setUpFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Task> = Task.fetchRequest()
        let predicate = NSPredicate(format: "hasCompleted == %@", NSNumber(value: true))
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "completionDate", ascending: true)]
        
        listDataSource = ListDataSource(tableView: tableView, managedObjectContext: dataController.viewContext, fetchRequest: fetchRequest, configure: { (completedTaskCell, task) in
            completedTaskCell.taskName.text = task.name
            completedTaskCell.categoryName.text = task.categoryName
            
            if let textColour = task.categoryColour {
                switch textColour {
                case "Red" : completedTaskCell.categoryName.textColor = UIColor(named: "Red")
                case "Yellow" : completedTaskCell.categoryName.textColor = UIColor(named: "Yellow")
                case "Blue" : completedTaskCell.categoryName.textColor = UIColor(named: "Blue")
                case "Green" : completedTaskCell.categoryName.textColor = UIColor(named: "Green")
                case "Brown" : completedTaskCell.categoryName.textColor = UIColor(named: "Brown")
                default:
                    completedTaskCell.categoryName.textColor = UIColor(named: "Black")
                }
            }
            
            if let completionDate = task.completionDate {
                completedTaskCell.completionDate.text = dateFormatter.string(from: completionDate)
            }
        })
        
        tableView.dataSource = listDataSource
    }


}
