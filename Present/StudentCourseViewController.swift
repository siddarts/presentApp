//
//  StudentCourseViewController.swift
//  Present
//
//  Created by Siddarth Sivakumar on 10/18/15.
//  Copyright © 2015 Siddarth Sivakumar. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

class StudentCourseViewController: UIViewController, CLLocationManagerDelegate {
    
    var course = PFObject(className: "Event")
    var currentUser = PFUser.currentUser()!
    var locationManager: CLLocationManager!
    var checkedIn = false

    @IBOutlet weak var courseNameLabel: UILabel!
    @IBAction func checkIn(sender: AnyObject) {
        getCheckedIn()
    }
    @IBOutlet weak var beaconStrength: UILabel!
    
    @IBOutlet weak var checkInStatus: UILabel!
    
    @IBOutlet weak var checkInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        courseNameLabel.text = course["name"] as! String
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        getCheckInStatus()
    }
    
    func getCheckedIn() {
        let allUserEvents = PFQuery(className: "User_Event")
        allUserEvents.whereKey("userId", equalTo: currentUser)
        allUserEvents.whereKey("eventId", equalTo: course)
        var userEvents : [AnyObject] = []
        do {
            userEvents = try allUserEvents.findObjects() as [PFObject]
            
        } catch _ {
            userEvents = []
        }
        let userEvent = userEvents[0]
        
        let log = PFObject(className: "Log")
        log.setObject(userEvent, forKey: "userEventObjectId")
        
        log.saveInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                _ = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
            } else {
                self.viewDidLoad()
            }
        }
    }
    
    func getCheckInStatus() {
        let allUserEvents = PFQuery(className: "User_Event")
        allUserEvents.whereKey("userId", equalTo: currentUser)
        allUserEvents.whereKey("eventId", equalTo: course)
        var userEvents : [AnyObject] = []
        do {
            userEvents = try allUserEvents.findObjects() as [PFObject]
            
        } catch _ {
            userEvents = []
        }
        let userEvent = userEvents[0]
        
        let allLogs = PFQuery(className: "Log")
        allLogs.whereKey("userEventObjectId", equalTo: userEvent)
        var logs : [AnyObject] = []
        do {
            logs = try allLogs.findObjects() as [PFObject]
            
        } catch _ {
            logs = []
        }
        if logs.count == 0 {
            self.checkInStatus.text = "Not Checked In"
            self.checkedIn = false
        }else {
            self.checkInStatus.text = "Checked In!"
            self.checkedIn = true
            self.checkInButton.enabled = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    print("in location manager func")
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let courseUuid = course["uuid"] as! String
        let courseMajor = CLBeaconMajorValue(course["major"] as! Int)
        let courseMinor = CLBeaconMinorValue(course["minor"] as! Int)
        let uuid = NSUUID(UUIDString: courseUuid)
        let courseName = course["name"] as! String
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid!, major: courseMajor, minor: courseMinor, identifier: courseName)
        
        locationManager.startMonitoringForRegion(beaconRegion)
        locationManager.startRangingBeaconsInRegion(beaconRegion)
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        if beacons.count > 0 {
            print("Found beacon")
            //            let beacon = beacons[0] as! CLBeacon
            let beacon = beacons[0]
            updateDistance(beacon.proximity)
        } else {
            updateDistance(.Unknown)
        }
    }
    
    func updateDistance(distance: CLProximity) {
        UIView.animateWithDuration(0.8) {
            switch distance {
            case .Unknown:
                self.view.backgroundColor = UIColor.grayColor()
                self.beaconStrength.text = "Not In Range"
            case .Far:
                self.view.backgroundColor = UIColor.orangeColor()
                self.beaconStrength.text = "Weak"
                if (self.checkedIn==false) {
                    self.checkInButton.enabled = true
                }
            case .Near:
                self.view.backgroundColor = UIColor.yellowColor()
                self.beaconStrength.text = "Average"
                if (self.checkedIn==false) {
                    self.checkInButton.enabled = true
                }
            case .Immediate:
                self.view.backgroundColor = UIColor.greenColor()
                self.beaconStrength.text = "Strong"
                if (self.checkedIn==false) {
                    self.checkInButton.enabled = true
                }
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
