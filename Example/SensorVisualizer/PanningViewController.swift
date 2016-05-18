//
//  PanningViewController.swift
//  SensorVisualizer
//
//  Created by Joseph Blau on 5/15/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class PanningViewController: UIViewController {

    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let scrollViewFrame = CGRectMake(0, 0, scrollViewWidth.constant, 10000)
        
        scrollView.contentSize = scrollViewFrame.size
        
        let gradient = CAGradientLayer()
        gradient.frame = scrollViewFrame
        gradient.colors = [UIColor(red: 0.149, green: 0.651, blue: 0.604, alpha: 1.0).CGColor,
                           UIColor(red: 0.400, green: 0.733, blue: 0.416, alpha: 1.0).CGColor,
                           UIColor(red: 0.612, green: 0.800, blue: 0.396, alpha: 1.0).CGColor,
                           UIColor(red: 0.831, green: 0.882, blue: 0.341, alpha: 1.0).CGColor,
                           UIColor(red: 1.000, green: 0.933, blue: 0.345, alpha: 1.0).CGColor,
                           UIColor(red: 1.000, green: 0.792, blue: 0.157, alpha: 1.0).CGColor,
                           UIColor(red: 1.000, green: 0.655, blue: 0.149, alpha: 1.0).CGColor,
                           UIColor(red: 1.000, green: 0.439, blue: 0.263, alpha: 1.0).CGColor,
                           UIColor(red: 0.937, green: 0.325, blue: 0.314, alpha: 1.0).CGColor,
                           UIColor(red: 0.925, green: 0.251, blue: 0.478, alpha: 1.0).CGColor,
                           UIColor(red: 0.671, green: 0.278, blue: 0.737, alpha: 1.0).CGColor,
                           UIColor(red: 0.494, green: 0.341, blue: 0.761, alpha: 1.0).CGColor,
                           UIColor(red: 0.361, green: 0.420, blue: 0.753, alpha: 1.0).CGColor,
                           UIColor(red: 0.259, green: 0.647, blue: 0.961, alpha: 1.0).CGColor,
                           UIColor(red: 0.161, green: 0.714, blue: 0.965, alpha: 1.0).CGColor,
                           UIColor(red: 0.149, green: 0.776, blue: 0.855, alpha: 1.0).CGColor]
        
        scrollView.layer.addSublayer(gradient)
    }
}
