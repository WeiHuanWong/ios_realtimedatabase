//
//  ViewController.swift
//  realtimedatabasetest
//
//  Created by oliver on 2018/12/19.
//  Copyright © 2018 oliver. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var orderKey: UITextField!
    @IBOutlet weak var content: UITextField!
    @IBOutlet weak var output: UITextView!
    
    
    var ref:DatabaseReference? = nil

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //匿名登入
        Auth.auth().signInAnonymously { (user, error) in
            if error == nil{
                print("User ID:\(user!.user.uid)")
            }else{
                print("Error msg:\(error!.localizedDescription)")
            }
        }
        //建立參考路徑
        ref = Database.database().reference().child("company/name")
        

        
  }
    
    
    
    //離開頁面關閉監聽
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref?.removeAllObservers()
    }
    
    @IBAction func addValue(_ sender: Any) {
        if let theKey = Int(orderKey.text ?? ""),let theContent = content.text{
            if theContent != ""{
                let value = ["key":theKey,"content":theContent,"time":ServerValue.timestamp()] as? [String:Any]
                ref?.childByAutoId().setValue(value)
            }
        }
        
    }
    
    @IBOutlet weak var limited: UISegmentedControl!
    @IBOutlet weak var number: UISegmentedControl!
    @IBOutlet weak var orderBy: UISegmentedControl!
    
    @IBAction func orserveData(_ sender: Any) {
        if let theKey = orderBy.titleForSegment(at: orderBy.selectedSegmentIndex){
            var queery = ref?.queryOrdered(byChild: theKey)
            if let theLimited = limited.titleForSegment(at: limited.selectedSegmentIndex){
                let theNumber = number.selectedSegmentIndex + 1
                if theLimited == "First"{
                    queery = queery?.queryLimited(toFirst: UInt(theNumber))
                }else{
                    queery = queery?.queryLimited(toLast: UInt(theNumber))
                }
                queery?.observeSingleEvent(of: .value, with: { (snapshot) in
                    self.output.text = "\(snapshot)"
                })
            }
        }
        
//        ref?.queryOrdered(byChild: "key")
//            .queryLimited(toLast: 3)
//            .observeSingleEvent(of: .value, with: { (snapshot) in
//            self.output.text = "\(snapshot)"
//        })
    }
    

    @IBOutlet weak var reNumero: UITextField!
    @IBAction func removeValue(_ sender: Any) {
        if let theReNummero = reNumero.text{
            if theReNummero != ""{
                let remove = Database.database().reference().child("company/name/\(theReNummero)")
                remove.removeValue()
                self.output.text = "\(theReNummero)的資料移除成功"
            }
        }
        
    }
    
    
}
