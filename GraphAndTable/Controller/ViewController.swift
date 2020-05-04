//
//  ViewController.swift
//  GraphAndTable
//
//  Created by Maksim on 04/05/2020.
//  Copyright © 2020 Maksim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var testSlider: UISlider!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var graphView: GraphView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testSlider.maximumValue = Float(graphView.graphPoints.count-1)
    }


    @IBAction func sliderValueChanged(_ sender: UISlider) {
        testLabel.text = String(sender.value)
        graphView.pointPositionX = CGFloat(sender.value)
        graphView.setNeedsDisplay()
    }
}

