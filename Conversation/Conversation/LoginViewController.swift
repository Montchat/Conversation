//
//  LoginViewController.swift
//  Login
//
//  Created by Joe E. on 10/15/15.
//  Copyright © 2015 Joe E. All rights reserved.
//

import UIKit
import Parse

private let USER = "user"
private let USERNAME = "\(USER)name"
private let PASSWORD = "password"
private let ERROR = "error"
private let EMPTY = ""

class LoginViewController: UIViewController {
    
    //MARK: -@IBOutlets
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    //MARK: - @IBActions
    @IBAction func pressedLogin(sender: AnyObject) {
        guard let username = usernameField.text where !username.isEmpty else { return
            alertError("Login Failed", reason: "Username is Empty")
        }
        
        guard let password = passwordField.text where !password.isEmpty else { return
            alertError("Login Failed", reason: "Password is Empty")
        }
        
        PFUser.logInWithUsernameInBackground(username, password:password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.connectUserToDevice()
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                
            } else {
                print(error)
                
            }
            
        }
        
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        usernameField.delegate = self
//        passwordField.delegate = self
//        emailTextField.delegate = self
//    }
    
    @IBAction func pressedRegister(sender: AnyObject) {
        guard let username = usernameField.text where username != EMPTY else { return
            alertError("Register Failed", reason: "Username is empty.")
            
        }
        
        guard let password = passwordField.text where password != EMPTY else { return
            alertError("Register Failed", reason: "Password is empty")
            
        }
        
        guard let email = emailTextField.text where email != EMPTY else { return
            alertError("Register Failed", reason: "Password is empty")
            
        }
        
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            
            if let error = error {
                _ = error.userInfo[ERROR] as? NSString
                
            } else {
                self.connectUserToDevice()
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                    
            }
            
        }
        
    }
    
    func connectUserToDevice() {
        let installation = PFInstallation.currentInstallation()
        installation[USER] = PFUser.currentUser()
        installation.saveInBackground()
        
    }
    
}

extension UIViewController {
    
    func alertError(title: String, reason:String) -> () {
    
        let alertVC  = UIAlertController(title: title, message: reason, preferredStyle: .Alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { (action) -> Void in
            
            alertVC.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alertVC, animated: true, completion: nil)
        
    }
    

    
}

//extension LoginViewController : UITextFieldDelegate {
//    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    
//    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    
////    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
////        let textField = UITextField()
////        for touch in touches {
////            textField.resignFirstResponder()
////        }
////
////    }
//    
//}
//