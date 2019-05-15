//
//  TaskCell.swift
//  To-do Manager
//
//  Created by MacbookPRO on 20/04/19.
//  Copyright © 2019 CodeSuit Developer. All rights reserved.
//

import UIKit

internal final class TaskCell: UITableViewCell, Cell {
    
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var completionDate: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        taskName.text = nil
        categoryName.text = nil
        completionDate.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
