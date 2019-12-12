//
//  UpdateViewController.swift
//  MAPD714-F2019-FinalTest-301090880
//
//  Created by Dipal Patel on 2019-12-11.
//  Copyright © 2019 Dipal Patel. All rights reserved.
//

import UIKit
import Firebase

class UpdateViewController: UIViewController {

    @IBOutlet weak var updatedWeight: UITextField!
    var bmi:bmi?
    var key:String?
    var switchStatus:String?
    var BMI:Double!
    var weight:Double!
    var bmiStatus = BMIStatus()
    var height:Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.bmi != nil {
            updatedWeight.text = self.bmi?.weight
            key = self.bmi?.uniqueId
            switchStatus = self.bmi?.unit
        }
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
    
    @IBAction func updateWeight(_ sender: Any) {
        let ref = Database.database().reference()
        
        weight = Double(updatedWeight.text!)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        
        //
       
        
        
        if(switchStatus == "Metric"){
            BMI = weight/height
        } else {
            BMI = (weight*703)/height!
        }
        
        let dictionary = [ "date"   : dateFormatter.string(from: Date()) ,
                           "weight" : updatedWeight.text!,
                           "BMI"    : self.bmiStatus.getBMIStatus(bmi: BMI)]
        
        
        let trackChildUpdates = ["/track/\(key!)": dictionary]
        ref.updateChildValues(trackChildUpdates, withCompletionBlock: { (error, ref) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
  
}
