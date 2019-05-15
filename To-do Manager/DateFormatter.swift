//
//  Date Formatter.swift
//  To-do Manager
//
//  Created by MacbookPRO on 20/04/19.
//  Copyright © 2019 CodeSuit Developer. All rights reserved.
//

import Foundation

// A date formatter for date text in task cells
let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "dd-MM-yyyy hh:mm"
    //df.dateStyle = .medium
    return df
}()
