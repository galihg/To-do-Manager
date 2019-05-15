//
//  Alert.swift
//  To-do Manager
//
//  Created by MacbookPRO on 02/05/19.
//  Copyright © 2019 CodeSuit Developer. All rights reserved.
//

import UIKit

class Alert: UIViewController {

    static func showMessage(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }

}
