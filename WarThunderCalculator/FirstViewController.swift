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

struct Constants {
    static let kNextButtonAcessoryInputAccessoryViewHeight: CGFloat = 44
}

extension UIResponder {
    
    private weak static var _currentFirstResponder: UIResponder? = nil
    
    public class func currentFirstResponder() -> UIResponder? {
        UIResponder._currentFirstResponder = nil
        UIApplication.sharedApplication().sendAction("findFirstResponder:", to: nil, from: nil, forEvent: nil)
        return UIResponder._currentFirstResponder
    }
    
    internal func findFirstResponder(sender: AnyObject) {
        UIResponder._currentFirstResponder = self
    }
}

class FirstViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var nextButtonInputAccessoryView: UIView!
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var planeOneBR: UITextField!
    @IBOutlet weak var planeTwoBR: UITextField!
    @IBOutlet weak var planeThreeBR: UITextField!
    @IBOutlet weak var totalRankLabel: UILabel!
    @IBOutlet weak var totalRankNumberLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        totalRankLabel.hidden = true
        totalRankNumberLabel.hidden = true
        
        planeOneBR.delegate = self
        planeTwoBR.delegate = self
        planeThreeBR.delegate = self
        
        planeOneBR.inputAccessoryView = nextButtonInputAccessoryView
        planeTwoBR.inputAccessoryView = nextButtonInputAccessoryView
        planeThreeBR.inputAccessoryView = nextButtonInputAccessoryView
    }
    
    override func viewWillLayoutSubviews() {
        nextButtonInputAccessoryView.frame = CGRect(x: 0, y: 0, width: CGRectGetWidth(view.bounds), height: Constants.kNextButtonAcessoryInputAccessoryViewHeight)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // Hide the total rank labels when the user is inputting new data
        totalRankLabel.hidden = true
        totalRankNumberLabel.hidden = true
        
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
    
    @IBAction func userDidTapInputAccessoryView(sender: AnyObject) {

        if UIResponder.currentFirstResponder() == planeOneBR {
            planeTwoBR.becomeFirstResponder()
        } else if UIResponder.currentFirstResponder() == planeTwoBR {
            planeThreeBR.becomeFirstResponder()
        } else if UIResponder.currentFirstResponder() == planeThreeBR {
            planeThreeBR.resignFirstResponder()
            goButtonDidClick(goButton)
        }
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
        if(brs[2] - brs[1] > 0.6) {
            brs[1] = brs[2] - 0.6
        }

        if(brs[2] - brs[0] > 0.6) {
            brs[0] = brs[2] - 0.6
        }
        
        var total = (brs[2] / 2) + (brs[0] + brs[1]) / 4
        
        totalRankLabel.text = "Total Rank"
        totalRankNumberLabel.text=("\(total)")
        
        totalRankLabel.hidden = false
        totalRankNumberLabel.hidden = false
        
    }
}