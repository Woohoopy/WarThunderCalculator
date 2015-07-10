//
//  FirstViewController.swift
//  WarThunderCalculator
//
//  Created by John  De Angulo on 7/9/15.
//  Copyright (c) 2015 WooHops. All rights reserved.
//

import UIKit

extension String {
    var toDouble: Double {
        return (self as NSString).doubleValue
    }
}

class FirstViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var planeOneBR: UITextField!
    @IBOutlet weak var planeTwoBR: UITextField!
    @IBOutlet weak var planeThreeBR: UITextField!
    @IBOutlet weak var totalRankLabel: UILabel!
    @IBOutlet weak var totalRankNumberLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        totalRankLabel.text = ""
        totalRankNumberLabel.text = ""
        
        self.planeOneBR.delegate = self
        self.planeTwoBR.delegate = self
        self.planeThreeBR.delegate = self
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
            // Get the attempted new string by replacing the new characters in the
            // appropriate range
            let newString = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            if count(newString) > 0 {
                // Find out whether the new string is numeric by using an NSScanner.
                // The scanDecimal method is invoked with NULL as value to simply scan
                // past a decimal integer representation.
                let scanner: NSScanner = NSScanner(string:newString)
                let isNumeric = scanner.scanDecimal(nil) && scanner.atEnd
                
                return isNumeric
                
            } else {
                // To allow for an empty text field
                return true
            }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //Responds to user textbox data entry
        if textField == planeOneBR {
            planeTwoBR.becomeFirstResponder()
            return false;
        }
        if textField == planeTwoBR {
            planeThreeBR.becomeFirstResponder()
            return false;
        }
        if textField == planeThreeBR {
            planeThreeBR.resignFirstResponder()
            goButtonDidClick(goButton)
            return true;
        }
        return true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goButtonDidClick(sender: UIButton) {
        // Read values last inputed by user
        var uno = planeOneBR.text.toDouble
        var dos = planeTwoBR.text.toDouble
        var tres = planeThreeBR.text.toDouble
        
        // Sort values in array of ascending order
        var brs:[Double] = [uno, dos, tres]
        brs.sort(<)
        
        // Any planes with BR difference greater than 0.6 should be changed to 0.6 less than the best plane
        if(brs[2] - brs[1] > 0.6){
            brs[1]=brs[2]-0.6
        }

        if(brs[2] - brs[0] > 0.6){
            brs[0]=brs[2]-0.6
        }
        
        var total = (brs[2]/2)+(brs[0]+brs[1])/4
        totalRankLabel.text = "Total Rank"
        totalRankNumberLabel.text=("\(total)")
    }
}