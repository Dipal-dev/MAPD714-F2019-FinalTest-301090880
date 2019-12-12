//
//  FIle Name: ViewController.swift
//  Project Name: MAPD714-F2019-FinalTest-301090880
//
//  Author: Dipal Patel
//  Student ID: 301090880
//  Date: 2019-12-11
//  Copyright © 2019 Dipal Patel. All rights reserved.
//


import UIKit
import Firebase

class ViewController: UIViewController {

    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var ageText: UITextField!
    
    @IBOutlet weak var genderText: UITextField!
    
    @IBOutlet weak var heightText: UITextField!
    
    @IBOutlet weak var weightText: UITextField!
    
    @IBOutlet weak var unitText: UILabel!
    
    @IBOutlet weak var switchValue: UISwitch!
    var switchState:Bool {
        return switchValue.isOn
    }
    
    
   
    @IBOutlet weak var BMIValue: UILabel!
    
    
    var height:Double!
    var weight:Double!
    var BMI:Double!
    var bmiStatus = BMIStatus()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(switchState == true){
            unitText.text = "Metric"
        } else {
            unitText.text = "Imperial"
        }
    }
    
    @IBAction func switchChange(_ sender: Any) {
        if(switchState == true){
            unitText.text = "Metric"
        } else {
            unitText.text = "Imperial"
        }
    }
    
    @IBAction func addUser(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        
        //Calculate BMI
        height = Double(heightText.text!)!
        weight = Double(weightText.text!)!
        
        if(switchState == true){
            BMI = weight/height
        } else {
            BMI = (weight*703)/height
        }
        
        
        let statusValue = self.bmiStatus.getBMIStatus(bmi: BMI)
        let BMIString = String(BMI!)
        BMIValue.text = statusValue
        
        
        
        //Add to User reference
        let ref = Database.database().reference()
        //let key = ref.child("user").childByAutoId().key
        
        let dictionaryTodo = [ "name"    : nameText.text ,
                               "age"     : ageText.text,
                               "gender"  : genderText.text,
                               "height"  : heightText.text]
        
        
        let childUpdates = ["/user/": dictionaryTodo]
        ref.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        
        //Add to BMI reference
        let tKey = ref.child("track").childByAutoId().key
        
        let dictionary = [ "date"   : dateFormatter.string(from: Date()) ,
                           "weight" : weightText.text!,
                           "BMI"    : BMIString,
                           "switchStatus": unitText.text]
        
        
        let trackChildUpdates = ["/track/\(tKey!)": dictionary]
        ref.updateChildValues(trackChildUpdates, withCompletionBlock: { (error, ref) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        
    }
    
   
    
}

