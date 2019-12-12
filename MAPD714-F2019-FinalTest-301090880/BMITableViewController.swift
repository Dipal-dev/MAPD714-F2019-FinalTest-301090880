//
//  FIle Name: BMITableViewController.swift
//  Project Name: MAPD714-F2019-FinalTest-301090880
//
//  Author: Dipal Patel
//  Student ID: 301090880
//  Date: 2019-12-11
//  Copyright © 2019 Dipal Patel. All rights reserved.
//

import UIKit
import Firebase

//tableview to display user's BMI value and weight
class BMITableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!

    
    var bmiList = [bmi]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    //load data from firebase realtime database
    func loadData() {
        self.bmiList.removeAll()
        let ref = Database.database().reference()
        ref.child("track").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    let trackData = bmi()
                    if let value = snapshot.value as? [String: Any] {
                        
                        trackData.uniqueId = snapshot.key
                        trackData.bmiStatus = value["BMI"] as? String ?? ""
                        trackData.date = value["date"] as? String ?? ""
                        trackData.weight = value["weight"] as? String ?? ""
                        trackData.unit = value["switchStatus"] as? String ?? ""
                        self.bmiList.append(trackData)
                    }
                }
            }
            self.tableView.reloadData()
            
        }) { (error) in
            print("Dipal"+error.localizedDescription)
        }
    }

    //method to get row count of tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bmiList.count
    }
    
    //this  function makes cell to be displayed in tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bmiCell")
        var str:String
        var str1:String
        var str2:String
        
        str = bmiList[indexPath.row].weight!
        str1 = bmiList[indexPath.row].bmiStatus!
        str2 = bmiList[indexPath.row].date!
        
        cell!.textLabel?.text = str+"      "+str1+"       "+str2// +
        return cell!
    }
    
   
    
    //when row is selected this function redirect to UpdateViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let bmiUpdate = self.storyboard!.instantiateViewController(withIdentifier: "updateVC") as! UpdateViewController
        bmiUpdate.bmi = bmiList[indexPath.row]
        
        self.navigationController?.pushViewController(bmiUpdate, animated: true)
        
    }
    
    //this function provide delete function on swipe left
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
           let alert = UIAlertController(title: nil, message: "Are you sure you'd like to delete this cell", preferredStyle: .alert)
            
            // yes action
            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                // put code to remove tableView cell here
                let postID = self.bmiList[indexPath.row].uniqueId
                Database.database().reference().child("track").child(postID!).removeValue()
                self.bmiList.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            alert.addAction(yesAction)
            // cancel action
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
    }


}
