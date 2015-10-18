//
//  SignUpViewController.swift
//  Present
//
//  Created by Annie Chen on 10/18/15.
//  Copyright © 2015 Siddarth Sivakumar. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBAction func createUser(sender: AnyObject) {
        signUp()
    }
    @IBOutlet weak var rolePicker: UIPickerView!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    var roles = ["Professor", "Student"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rolePicker.delegate = self
        rolePicker.dataSource = self
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func signUp() {
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        user.email = emailField.text
        user.setObject(phoneField.text!, forKey: "phone")
        user.setObject(firstNameField.text!, forKey: "firstName")
        user.setObject(lastNameField.text!, forKey: "lastName")
        user.setValue(roles[rolePicker.selectedRowInComponent(0)], forKey: "role")
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                _ = error.userInfo["error"] as? NSString
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if(self.roles[self.rolePicker.selectedRowInComponent(0)]=="Professor"){
                    let home : UIViewController = storyboard.instantiateViewControllerWithIdentifier("Home")
                    self.presentViewController(home, animated: true, completion: nil)
                }
                else{
                    let studentHome : UIViewController = storyboard.instantiateViewControllerWithIdentifier("StudentNav")
                    self.presentViewController(studentHome, animated: true, completion: nil)
                }
            }
        }
        
    }

    //Code for Picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roles.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return roles[row]
    }
}
