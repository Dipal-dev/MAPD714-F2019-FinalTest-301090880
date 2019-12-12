//
//  AddViewController.swift
//  MAPD714-F2019-FinalTest-301090880
//
//  Created by Dipal Patel on 2019-12-11.
//  Copyright © 2019 Dipal Patel. All rights reserved.
//

import UIKit
import Firebase
class AddViewController: UIViewController {

    
    
    
    @IBOutlet weak var addWeight: UITextField!
    
    @IBOutlet weak var unitText: UILabel!
    
    @IBOutlet weak var switchValue: UISwitch!
    var switchState:Bool {
        return switchValue.isOn
    }
    
    @IBOutlet weak var BMIValue: UILabel!
    
    var bmi:bmi?
    var key:String?
    var switchStatus:String?
    var BMI:Double!
    var weight:Double!
    var bmiStatus = BMIStatus()
    var height:Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func switchChange(_ sender: Any) {
        if(switchState == true){
            unitText.text = "Metric"
        } else {
            unitText.text = "Imperial"
        }
    }
    

    @IBAction func addWeight(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        
        weight = Double(addWeight.text!)!
        
        if(switchState == true){
            BMI = weight/height
        } else {
            BMI = (weight*703)/height
        }
        
        let ref = Database.database().reference()
        let tKey = ref.child("track").childByAutoId().key
        
        let statusValue = self.bmiStatus.getBMIStatus(bmi: BMI)
        let BMIString = String(BMI!)
        BMIValue.text = statusValue
        
        let dictionary = [ "date"   : dateFormatter.string(from: Date()) ,
                           "weight" : addWeight.text!,
                           "BMI"    : BMIString,
                           "switchStatus": unitText.text]
        
        
        let trackChildUpdates = ["/track/\(tKey!)": dictionary]
        ref.updateChildValues(trackChildUpdates, withCompletionBlock: { (error, ref) -> Void in
            //self.navigationController?.popViewController(animated: true)
        })
    }

}
