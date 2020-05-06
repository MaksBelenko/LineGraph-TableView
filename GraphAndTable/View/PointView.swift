//
//  PointView.swift
//  GraphAndTable
//
//  Created by Maksim on 05/05/2020.
//  Copyright © 2020 Maksim. All rights reserved.
//

import UIKit

@IBDesignable class PointView: UIView {

    // MARK: - @IBInspectable
    @IBInspectable var fillColour: UIColor = .white
    @IBInspectable var circleDiameter: CGFloat = 12.0
    
    
    // MARK: - Fields
    var pointPositionX: CGFloat = 0
    var graphCGPoints: [CGPoint] = [CGPoint(x: 50, y: 50)]
  
    
    override func draw(_ rect: CGRect) {
        
        fillColour.set()
        
        let x: CGFloat
        let y: CGFloat

        let i = Int(pointPositionX)
        if i < graphCGPoints.count - 1 {
            let i = Int(pointPositionX)
            let beginPoint = CGPoint(x: graphCGPoints[i].x, y: graphCGPoints[i].y)
            let finishPoint = CGPoint(x: graphCGPoints[i+1].x, y: graphCGPoints[i+1].y)

            
            let midP = midPoint(p1: beginPoint, p2: finishPoint)
            let remainder = pointPositionX.truncatingRemainder(dividingBy: 1)
            let controlP = (remainder < 0.5) ? controlPoint(p1: midP, p2: beginPoint) : controlPoint(p1: midP, p2: finishPoint)
            
            let percentage = (remainder < 0.5) ? remainder*2 : (remainder - 0.5)*2
            
            if remainder < 0.5 {
                x = quadBezier(t: percentage, start: beginPoint.x, c1: controlP.x, end: midP.x)
                y = quadBezier(t: percentage, start: beginPoint.y, c1: controlP.y, end: midP.y)
            } else {
                x = quadBezier(t: percentage, start: midP.x, c1: controlP.x, end: finishPoint.x)
                y = quadBezier(t: percentage, start: midP.y, c1: controlP.y, end: finishPoint.y)
            }
        } else {
            x = graphCGPoints[i].x
            y = graphCGPoints[i].y
        }

        var point = CGPoint(x: x, y: y)
        point.x -= circleDiameter / 2
        point.y -= circleDiameter / 2

        let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: circleDiameter, height: circleDiameter)))
        circle.fill()
        
        
        
        // ------- Draw rectangle for point
//        let rectHeight: CGFloat = 30
//        let rectWidth: CGFloat = 60
//        let priceRect = CGRect(x: x - rectWidth/2,
//                               y: y - rectHeight - 20,
//                               width: rectWidth,
//                               height: rectHeight)
//
//        let path = UIBezierPath(roundedRect: priceRect,
//                                byRoundingCorners: .allCorners,
//                                cornerRadii: CGSize(width: 8.0, height: 8.0))
//        path.addClip()
//        
//        path.fill()
//        
//        let attributes = [
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0),
//            NSAttributedString.Key.foregroundColor: UIColor.blue
//        ]
//
//        let myText = "HELLO"
//        let attributedString = NSAttributedString(string: myText, attributes: attributes)
//
//        attributedString.draw(in: priceRect)
    }

    
    
    
    // MARK: - Bezier Helpers
    
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
    private func midPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }
    
    
    /**
     Calculates control point for point to be used in Quad Bezier
     - Parameter p1: First point
     - Parameter p2: Second point
     */
    private func controlPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        var controlPoint = midPoint(p1: p1, p2: p2)
        let dY = abs(p2.y - controlPoint.y)
        
        controlPoint.y += (p1.y < p2.y) ? dY : -dY
        return controlPoint
    }


}



// MARK: - PointDataDelegate
extension PointView: PointDataDelegate {
    func setPointViewData(graphCGPoints: [CGPoint]) {
        self.graphCGPoints = graphCGPoints
    }
}
