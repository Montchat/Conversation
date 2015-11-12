//
//  UsersTableViewController.swift
//  Conversation
//
//  Created by Joe E. on 11/3/15.
//  Copyright © 2015 Joe E. All rights reserved.
//

import UIKit
import Parse

private let USER_CELL = "UserCell"
private let OBJECT_ID = "objectID"
class UsersTableViewController: UITableViewController {
    
    var users: [PFUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userQuery = PFUser.query()
        
        if let objectId = PFUser.currentUser()?.objectId {
            userQuery?.whereKey(OBJECT_ID, notEqualTo: objectId)
            
        }

        userQuery?.findObjectsInBackgroundWithBlock({ [weak self] (objects, error) -> Void in
            if let users = objects as? [PFUser] {
                self?.users = users
                self?.tableView.reloadData()
            }

        })

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(USER_CELL, forIndexPath: indexPath)
        
        cell.textLabel?.text = users[indexPath.row].username

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //sender is the obeject that triggered the segue
        //we are guarding to make sure it is a UITableViewCell
        guard let cell = sender as? UITableViewCell else { return }
        
        //we are guarding to make sure it is a ConversationViewController
        //we are also casting to use the "user" porperty below
        guard let convoVC = segue.destinationViewController as? ConversationViewController else { return }
        
        //get the indexPath from tableView for the cell
        guard let indexPath = tableView.indexPathForCell(cell) else { return }
        
        //user indexPath.row to get the user for that cell
        //setting user on convoVC to user as the recevier
        convoVC.user = users[indexPath.row]
        
        
        
    }

}