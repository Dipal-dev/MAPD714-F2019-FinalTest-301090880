
//
//  FIle Name: BMIStatus.swift
//  Project Name: MAPD714-F2019-FinalTest-301090880
//
//  Author: Dipal Patel
//  Student ID: 301090880
//  Date: 2019-12-11
//  Copyright © 2019 Dipal Patel. All rights reserved.
//



import Foundation

//Class to get status using BMI
class BMIStatus {
    var status:String?
    
    public func getBMIStatus(bmi: Double) ->String {
       
        if(bmi<16){
            return "Severe Thinness"
        }else if(bmi == 16 && bmi == 17){
            return "Moderate Thinness"
        }else if(bmi<18.5){
            return "Mild Thinness"
        }else if(bmi<25){
            return "Normal"
        }else if(bmi<30){
            return "Overweight"
        }else if(bmi<35){
            return "Obese Class 1"
        }else if(bmi<=40){
            return "Obese Class 2"
        }else if(bmi>40){
            return "Obese Class 3"
        } else {
            return ""
        }
        
    }
}
