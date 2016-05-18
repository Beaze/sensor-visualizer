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

    let options = ["Touches", "Map", "Panning"]
    
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
        let option = options[indexPath.row]
        self.performSegueWithIdentifier("Show \(option)", sender: self)
    }
}
