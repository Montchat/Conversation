//
//  ConversationViewController.swift
//  Conversation
//
//  Created by Joe E. on 11/3/15.
//  Copyright © 2015 Joe E. All rights reserved.
//

import UIKit
import Parse

private let MESSAGE = "Message"
private let SENDER = "sender"
private let RECEIVER = "receiver"
private let CONTENT = "content"
private let USER = "user"

class ConversationViewController: UIViewController {
    
    //MARK: - Properties
    var messages: [PFObject] = []
    var user: PFUser! {
        didSet {
            guard let me = PFUser.currentUser() else { return }
            let messageQuery = PFQuery(className: MESSAGE)
            messageQuery.whereKey(SENDER, containedIn: [user, me])
            messageQuery.whereKey(RECEIVER, containedIn: [user, me])
            messageQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                self.messages = objects ?? []
                
            }
            
        }
        
    }
    
    //MARK: - @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!

    @IBAction func sendMessagePressed(sender: AnyObject) {
        
        guard let content = messageField.text where content != "" else { return }
        
        let message = PFObject(className: MESSAGE)
        message[SENDER] = PFUser.currentUser()
        message[RECEIVER] = user
        message[CONTENT] = content
        
        message.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            let pushQuery = PFInstallation.query()
            pushQuery?.whereKey(USER, equalTo: self.user)
            
            let push = PFPush()
            push.setQuery(pushQuery)
            push.setMessage("\(PFUser.currentUser()?.username ?? ""): \(content)")
            push.sendPushInBackground()
                
        }
        
        
        messageField.text = nil
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ConversationViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("", forIndexPath: indexPath)
        let message = messages[indexPath.row]
        cell.textLabel?.text = message[CONTENT] as? String
        
        return cell
        
    }
    
}