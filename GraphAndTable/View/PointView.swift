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
    
    let bezierHelper = BezierHelper()
    
  
    // MARK: - Draw
    override func draw(_ rect: CGRect) {
        
        fillColour.set()
        
        let x: CGFloat
        let y: CGFloat

        let i = Int(pointPositionX)
        if i < graphCGPoints.count - 1 {
            let i = Int(pointPositionX)
            let beginPoint = CGPoint(x: graphCGPoints[i].x, y: graphCGPoints[i].y)
            let finishPoint = CGPoint(x: graphCGPoints[i+1].x, y: graphCGPoints[i+1].y)

            
            let midP = bezierHelper.midPoint(p1: beginPoint, p2: finishPoint)
            let remainder = pointPositionX.truncatingRemainder(dividingBy: 1)
            let controlP = (remainder < 0.5) ? bezierHelper.controlPoint(p1: midP, p2: beginPoint) : bezierHelper.controlPoint(p1: midP, p2: finishPoint)
            
            let percentage = (remainder < 0.5) ? remainder*2 : (remainder - 0.5)*2
            
            if remainder < 0.5 {
                x = bezierHelper.quadBezier(t: percentage, start: beginPoint.x, c1: controlP.x, end: midP.x)
                y = bezierHelper.quadBezier(t: percentage, start: beginPoint.y, c1: controlP.y, end: midP.y)
            } else {
                x = bezierHelper.quadBezier(t: percentage, start: midP.x, c1: controlP.x, end: finishPoint.x)
                y = bezierHelper.quadBezier(t: percentage, start: midP.y, c1: controlP.y, end: finishPoint.y)
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
        
        
        
//        // ------- Draw rectangle for point
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
//            NSAttributedString.Key.foregroundColor: UIColor.white,
//            NSAttributedString.Key.backgroundColor: UIColor.green
//        ]
//
//        let myText = "HELLO"
//        let attributedString = NSAttributedString(string: myText, attributes: attributes)
//
//        attributedString.draw(in: priceRect)
    }

}



// MARK: - PointDataDelegate
extension PointView: PointDataDelegate {
    func setPointViewData(graphCGPoints: [CGPoint]) {
        self.graphCGPoints = graphCGPoints
    }
}
