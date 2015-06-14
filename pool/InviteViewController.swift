//
//  InviteViewController.swift
//  
//
//  Created by Devran Uenal on 13.06.15.
//
//

import UIKit

class InviteViewController: UITableViewController, UISearchBarDelegate {
    var data: [User] = []
    var searchBar: UISearchBar
    var searchTimer: NSTimer
    
    var _id: String
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(id: String) {
        self.searchBar = UISearchBar()
        self.searchTimer = NSTimer()
        self._id = id
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        searchBar.delegate          = self
        searchBar.showsCancelButton = true
        searchBar.placeholder       = "Search friend …"
        
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
    
    // tableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Friends"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
        let cellData = self.data[indexPath.row]
        cell.textLabel?.text = cellData.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if
            let name = self.data[indexPath.row].name
        {
            Activity.invite(_id, name: name)?.method("POST").bodyParameters(["name": name]).success({ (data, response) -> () in
                self.dismissViewControllerAnimated(true, completion: nil)
            }).call()
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.tableView.reloadData()
        
        self.searchTimer.invalidate()
        self.searchTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "search:", userInfo: ["q": searchText], repeats: false)
    }
    
    func search(timer: NSTimer) {
        if
            let userInfo = timer.userInfo as? [String: String],
            let query = userInfo["q"]
        {
            if count(query) > 0 {
                self.data = [
                    User(data: ["name": "olcaybuyan"]),
                    User(data: ["name": "thomaspockrandt"]),
                    User(data: ["name": "donnieraycrisp"]),
                    User(data: ["name": "maccosmo"]),
                ]
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
