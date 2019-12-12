//
//  FIle Name: UpdateViewController.swift
//  Project Name: MAPD714-F2019-FinalTest-301090880
//
//  Author: Dipal Patel
//  Student ID: 301090880
//  Date: 2019-12-11
//  Copyright © 2019 Dipal Patel. All rights reserved.
//


import UIKit
import Firebase

//Update weight class
class UpdateViewController: UIViewController {

    @IBOutlet weak var updatedWeight: UITextField!
    
    
    @IBOutlet weak var unit: UILabel!
    
    var bmi:bmi?
    var key:String?
    var switchStatus:String?
    var BMI:Double!
    var weight:Double!
    var bmiStatus = BMIStatus()
    var height:Double!
    var unitText:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.bmi != nil {
            updatedWeight.text = self.bmi?.weight
            key = self.bmi?.uniqueId
            switchStatus = self.bmi?.unit
            unit.text = switchStatus
        }
        //fetch data from row to update view controller
        let ref = Database.database().reference()
        ref.child("user").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let heightValue = value?["height"] as? String ?? ""
            self.height = Double(heightValue)!
            print("Dipal")
            print(self.height!)
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
       
    }
    
    //Update Value of weight and calculate BMI accordingly
    @IBAction func updateWeight(_ sender: Any) {
        let ref = Database.database().reference()
        
        weight = Double(updatedWeight.text!)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        
        if(switchStatus == "Metric"){
            BMI = weight/(height*height)
        } else {
            BMI = (weight*703)/(height*height)
        }
        
        let dictionary = [ "date"   : dateFormatter.string(from: Date()) ,
                           "weight" : updatedWeight.text!,
                           "BMI"    : String(BMI.truncate(places: 2)),
                           "switchStatus": switchStatus]
        
        
        let trackChildUpdates = ["/track/\(key!)": dictionary]
        ref.updateChildValues(trackChildUpdates, withCompletionBlock: { (error, ref) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
  
}
