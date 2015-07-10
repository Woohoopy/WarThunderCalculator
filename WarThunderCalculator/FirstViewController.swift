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

class FirstViewController: UIViewController {
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var planeOneBR: UITextField!
    @IBOutlet weak var planeTwoBR: UITextField!
    @IBOutlet weak var planeThreeBR: UITextField!
    @IBOutlet weak var totalRankLabel: UILabel!
    @IBOutlet weak var totalRankNumberLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        totalRankLabel.text = "";
        totalRankNumberLabel.text = "";
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
        var brs:[Double] = [uno,dos,tres]
        brs.sort(<)
        // Any planes with BR difference greater than 0.6 should be changed to 0.6 less than the best plane
        if(brs[2]-brs[1]>0.6){
        brs[1]=brs[2]-0.6
        }
        if(brs[2]-brs[0]>0.6){
        brs[0]=brs[2]-0.6
        }
        
        var total = (brs[2]/2)+(brs[0]+brs[1])/4
        totalRankLabel.text = "Total Rank"
        totalRankNumberLabel.text=("\(total)")
        
        
    }

}

