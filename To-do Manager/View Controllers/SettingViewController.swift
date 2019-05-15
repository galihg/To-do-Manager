//
//  settingViewController.swift
//  To-do Manager
//
//  Created by MacbookPRO on 19/04/19.
//  Copyright © 2019 CodeSuit Developer. All rights reserved.
//

import UIKit
import UserNotifications

class SettingViewController: UIViewController {
    
    @IBOutlet weak var switchButton: UISwitch!
    
    var dataController:DataController!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if defaults.object(forKey: "switchState") != nil {
            let state = defaults.object(forKey: "switchState")
            let notifState = state as! Bool
            switchButton.isOn = notifState
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc  = segue.destination as? AddCategoryViewController {
            vc.dataController = dataController
        } else if let vc = segue.destination as? CategoriesListViewController {
            vc.dataController = dataController
        }
    }
    
    func saveSwitchesStates() {
        defaults.set(switchButton.isOn, forKey: "switchState")
    }
    
    @IBAction func switchNotification(_ sender: Any) {
        let alarmTime = Date()
        if switchButton.isOn {
            SetNotification.toggleNotification(title: "Check if you have any task to complete!", date: alarmTime, subtitle: "")
        } else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["content"])
        }
        
        saveSwitchesStates()
    }
    

}


