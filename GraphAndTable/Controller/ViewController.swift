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
    @IBOutlet weak var pointView: PointView!
    
    
    var pointPositionX: CGFloat = 0
    var graphCGPoints = [CGPoint]()
    var lineCoef = [LineCoefficients]()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testSlider.maximumValue = Float(graphView.graphPointsY.count-1)
    
        graphView.pointDataDelegate = pointView
    }


    @IBAction func sliderValueChanged(_ sender: UISlider) {
        testLabel.text = String(sender.value)
        
        pointView.pointPositionX = CGFloat(sender.value)
        pointView.setNeedsDisplay()
    }
}

