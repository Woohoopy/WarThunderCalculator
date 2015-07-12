//
//  FirstViewController.swift
//  WarThunderCalculator
//
//  Created by Woohoopy on 7/9/15.
//  Copyright (c) 2015 WooHops. All rights reserved.
//

import UIKit

extension String {
    var toDouble: Double {
        return (self as NSString).doubleValue
    }
}

// Provides extension to use HEX values for UIColor as opposed to simply RGB
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
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
    @IBOutlet weak var nextLabel: UILabel!
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var planeOneBR: UITextField!
    @IBOutlet weak var planeTwoBR: UITextField!
    @IBOutlet weak var planeThreeBR: UITextField!
    @IBOutlet weak var totalRankLabel: UILabel!
    @IBOutlet weak var totalRankNumberLabel: UILabel!
    
    var kbHeight: CGFloat!

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
        
        // Change style of UI Navigation Controller
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.4)
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Light", size: 19)!,NSForegroundColorAttributeName : UIColor.whiteColor()]
        // self.navigationController!.navigationBar.shadowImage = UIImage()
        
        // Sets battery and time text to white
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
        
        
    }
    
    override func viewWillLayoutSubviews() {
        nextButtonInputAccessoryView.frame = CGRect(x: 0, y: 0, width: CGRectGetWidth(view.bounds), height: Constants.kNextButtonAcessoryInputAccessoryViewHeight)
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                kbHeight = keyboardSize.height
                self.animateTextField(true)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.animateTextField(false)
    }
    
    func animateTextField(up: Bool) {
        // '-160' Value fine tunes the degree to which the applications scrolls
        var movement = (up ? -(kbHeight-160) : kbHeight-160)
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        })
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
            nextLabel.text = "Next"
        } else if UIResponder.currentFirstResponder() == planeTwoBR {
            planeThreeBR.becomeFirstResponder()
            nextLabel.text = "Go!"
        } else if UIResponder.currentFirstResponder() == planeThreeBR {
            planeThreeBR.resignFirstResponder()
            goButtonDidClick(goButton)
        }
    }
    
    @IBAction func userDidTapTextFieldOne(sender: UITextField) {
        nextLabel.text = "Next"
    }
    
    @IBAction func userDidTapTextFieldTwo(sender: UITextField) {
        nextLabel.text = "Next"
    }
    @IBAction func userDidTapTextFieldThree(sender: UITextField) {
        nextLabel.text = "Go!"
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