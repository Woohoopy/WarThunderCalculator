//
//  FirstViewController.swift
//  WarThunderCalculator
//
//  Created by John  De Angulo on 7/9/15.
//  Copyright (c) 2015 WooHops. All rights reserved.
//

import UIKit

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
        var uno = (planeOneBR.text as NSString).doubleValue
        var dos = (planeTwoBR.text as NSString).doubleValue
        var tres = (planeThreeBR.text as NSString).doubleValue
        var brs:[Double] = [uno,dos,tres]
        brs.sort(<)
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

