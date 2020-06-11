//
//  UIBezierPath+Ext.swift
//  GraphAndTable
//
//  Created by Maksim on 05/05/2020.
//  Copyright © 2020 Maksim. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

extension UIBezierPath {
    
    /// Creates smooth line Bezier path from points
    convenience init?(curveFromPoints points: [CGPoint]) {
        guard points.count > 1 else { return nil }
        self.init()
        
        var startPoint = points[0]
        move(to: startPoint)
        
        let bezierHelper = BezierHelper()
        
        for endPoint in points {
            let mid = bezierHelper.midPoint(p1: startPoint, p2: endPoint)
            addQuadCurve(to: mid, controlPoint: bezierHelper.controlPoint(p1: mid, p2: startPoint))
            addQuadCurve(to: endPoint, controlPoint: bezierHelper.controlPoint(p1: mid, p2: endPoint))
            
            startPoint = endPoint
        }
    }

}
