//
//  BezierHelper.swift
//  GraphAndTable
//
//  Created by Maksim on 11/06/2020.
//  Copyright © 2020 Maksim. All rights reserved.
//

import CoreGraphics

class BezierHelper {
    
    /**
    Calculates Cubic Bezier path
    
        let x = QuadBezier(t: 0.3, start: A.x, c1: C1.x, end: B.x);
        let y = QuadBezier(t: 0.3, start: A.y, c1: C1.y, end: B.y);
        return CGPoint(x: x, y: y);
       For example, lets say you have two points A and B,
       and a control point C1. You want to calculate the
       value 30% of the way between the two of them. Call
       the function twice, once for the x value, once for
       the y. Combine the two to produce a destination point.
    */
    func quadBezier(t: CGFloat, start: CGFloat, c1: CGFloat, end: CGFloat) -> CGFloat {
        let t_ : CGFloat = (1.0 - t);
        let tt_: CGFloat = t_ * t_;
        let tt : CGFloat = t * t;
        
        return start * tt_
               + 2.0 *  c1 * t_ * t
               + end * tt;
    }
    
    
    /**
     Calculates Middle Point between two points
     - Parameter p1: First point
     - Parameter p2: Second point
     */
    func midPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }
    
    
    /**
     Calculates control point for point to be used in Quad Bezier
     - Parameter p1: First point
     - Parameter p2: Second point
     */
    func controlPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        var controlPoint = midPoint(p1: p1, p2: p2)
        let dY = abs(p2.y - controlPoint.y)
        
        controlPoint.y += (p1.y < p2.y) ? dY : -dY
        return controlPoint
    }
}
