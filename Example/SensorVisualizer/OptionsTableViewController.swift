//
//  OptionsTableViewController.swift
//  
//
//  Created by Joseph Blau on 3/22/16.
//
//

import UIKit

let resuseIdentifer = "Option Cell"

class OptionsTableViewController: UITableViewController {

    let options = ["Touches", "Map"]
    
    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(resuseIdentifer, forIndexPath: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegueWithIdentifier("Show Touches", sender: self)
        case 1:
            self.performSegueWithIdentifier("Show Map", sender: self)
        default:
            break
        }
    }
}
