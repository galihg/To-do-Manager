//
//  CompletedTaskCell.swift
//  To-do Manager
//
//  Created by MacbookPRO on 20/04/19.
//  Copyright © 2019 CodeSuit Developer. All rights reserved.
//

import UIKit

class CompletedTaskCell: UITableViewCell {

    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var completionDate: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        taskName.text = nil
        categoryName.text = nil
        completionDate.text = nil
    }

}
