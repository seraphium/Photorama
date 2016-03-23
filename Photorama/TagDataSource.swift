//
//  TagDataSource.swift
//  Photorama
//
//  Created by Jackie Zhang on 16/3/23.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit
import CoreData

class TagDataSource:NSObject, UITableViewDataSource {
    var tags: [NSManagedObject] = []

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        let tag = tags[indexPath.row]
        let name = tag.valueForKey("name") as! String
        cell.textLabel?.text = name
        
        return cell
    }
}
