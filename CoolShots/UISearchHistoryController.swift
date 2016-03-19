//
//  UISearchHistory.swift
//  CoolShots
//
//  Created by Joseph Kalash on 3/19/16.
//  Copyright © 2016 Joseph Kalash. All rights reserved.
//

import UIKit

@objc protocol UISearchHistoryDelegate {
    optional func didSelectHistory(manager: UISearchHistoryController, selection: String)
}

class UISearchHistoryController : UITableViewController {
    
    let defaultsDataKey = "DEFAULTS_SEARCH_HISTORY"
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var delegate : UISearchHistoryDelegate?
    
    var history : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let searchHistory = userDefaults.objectForKey(defaultsDataKey) as? [String] {
            history = searchHistory
        }
        
        self.tableView.separatorColor = UIColor.whiteColor()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        if let c = tableView.dequeueReusableCellWithIdentifier("historyCell") { cell = c }
        else {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "historyCell")
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }

        cell.textLabel?.text = history[history.count - indexPath.row - 1]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectHistory?(self, selection: history[history.count - indexPath.row - 1])
    }
    
    func addToHistory(search: String) {
        history.append(search)
        dispatch_async(dispatch_get_main_queue()) { () -> Void in self.tableView.reloadData()}
        userDefaults.setObject(history, forKey: defaultsDataKey)
        userDefaults.synchronize()
    }

}
