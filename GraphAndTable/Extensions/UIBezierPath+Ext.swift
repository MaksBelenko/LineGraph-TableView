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
        
        for endPoint in points {
            let mid = midPoint(p1: startPoint, p2: endPoint)
            addQuadCurve(to: mid, controlPoint: controlPoint(p1: mid, p2: startPoint))
            addQuadCurve(to: endPoint, controlPoint: controlPoint(p1: mid, p2: endPoint))
            
            startPoint = endPoint
        }
    }
    
    private func midPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }
    
    private func controlPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        var controlPoint = midPoint(p1: p1, p2: p2)
        let dY = abs(p2.y - controlPoint.y)
        
        controlPoint.y += (p1.y < p2.y) ? dY : -dY
        return controlPoint
    }
}
