//
//  AddClassViewController.swift
//  Present
//
//  Created by Siddarth Sivakumar on 10/18/15.
//  Copyright © 2015 Siddarth Sivakumar. All rights reserved.
//

import UIKit
import Parse

class AddClassViewController: UIViewController {
    
    let currentUser = PFUser.currentUser()!

    @IBOutlet weak var majorInput: UITextField!
    @IBOutlet weak var minorInput: UITextField!
    
    @IBAction func saveClass(sender: AnyObject) {
        addClass()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addClass() {
        if (majorInput.text!.isEmpty || minorInput.text!.isEmpty) {
            let alert = UIAlertView()
            alert.title = "Missing Fields"
            alert.message = "One or more of the fields are blank...please complete"
            alert.addButtonWithTitle("Ok")
            alert.show()
        } else {
            print("in add class function")
            let allCourses = PFQuery(className: "Event")
            let major = Int(majorInput.text!)
            let minor = Int(minorInput.text!)
//            print(major)
//            print(minor)
            allCourses.whereKey("major", equalTo: major!)
            allCourses.whereKey("minor", equalTo: minor!)
            var courseObjects : [AnyObject] = []
            do {
                courseObjects = try allCourses.findObjects() as [PFObject]
                
            } catch _ {
                courseObjects = []
            }
            print(courseObjects)
            let courseObject = courseObjects[0]
            let userEvent = PFObject(className: "User_Event")
            userEvent.setObject(courseObject, forKey: "eventId")
            userEvent.setObject(currentUser, forKey: "userId")
            
            userEvent.saveInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    _ = error.userInfo["error"] as? NSString
                    // Show the errorString somewhere and let the user try again.
                } else {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
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
