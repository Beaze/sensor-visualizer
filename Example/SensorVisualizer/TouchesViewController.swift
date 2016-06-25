//
//  TouchesViewController.swift
//  SensorVisualizer
//
//  Created by Joseph Blau on 6/25/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class TouchesViewController: UIViewController {

    @IBAction func touchedButton(_ sender: UIButton) {
        if let title = sender.titleLabel?.text {
            navigationItem.prompt = "Pressed \(title.capitalized)"
            clearPrompt()
        }
    }
    
    @IBAction func selectSegement(_ sender: UISegmentedControl) {
        if let selectedTitle = sender.titleForSegment(at: sender.selectedSegmentIndex) {
            navigationItem.prompt = "Segment \(selectedTitle.capitalized)"
            clearPrompt()
        }
    }
    
    @IBAction func toggleSwitch(_ sender: UISwitch) {
        navigationItem.prompt = "Switch \(sender.isOn.description.capitalized)"
        clearPrompt()
    }

    @IBAction func pressStepper(_ sender: UIStepper) {
        navigationItem.prompt = "Step \(sender.value)"
        clearPrompt()
    }
    
    // MARK: - Private
    
    private func clearPrompt() {
        DispatchQueue.main.after(walltime: .now() + 4.0) {
            self.navigationItem.prompt = ""
        }
    }
}
