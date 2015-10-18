//
//  SettingsController.swift
//  Present
//
//  Created by Annie Chen on 10/16/15.
//  Copyright © 2015 Siddarth Sivakumar. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {


    @IBAction func back(sender: AnyObject) {
        if let navigationController = self.navigationController
        {
            navigationController.popViewControllerAnimated(true)
        }
    }
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
