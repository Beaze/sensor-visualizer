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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resuseIdentifer, for: indexPath)
        cell.textLabel?.text = options[(indexPath as NSIndexPath).row]
        return cell
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = options[(indexPath as NSIndexPath).row]
        self.performSegue(withIdentifier: "Show \(option)", sender: self)
    }
}
