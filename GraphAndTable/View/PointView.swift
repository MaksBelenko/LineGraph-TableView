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
    var lineCoef = [LineCoefficients]()
    
    
    
    /**
     Gets coefficient(k) and offset(b) as line has equation y = kx + b
     - Parameter startPoint: First point on the line
     - Parameter endPoint: Another point on the line
     */
    private func getLineCoeffients(startPoint: CGPoint, endPoint: CGPoint) -> LineCoefficients {
        let coefficient = CGFloat((endPoint.y - startPoint.y) / (endPoint.x - startPoint.x))
        let offset = endPoint.y - coefficient * endPoint.x
        return LineCoefficients(coefficient: coefficient, offset: offset)
    }
    
    
    
    
    override func draw(_ rect: CGRect) {
        
        fillColour.set()
        
        let x: CGFloat
        let y: CGFloat

        let i = Int(pointPositionX)
        if i < graphCGPoints.count - 1 {
            let i = Int(pointPositionX)
            let beginPoint = CGPoint(x: graphCGPoints[i].x, y: graphCGPoints[i].y)
            let finishPoint = CGPoint(x: graphCGPoints[i+1].x, y: graphCGPoints[i+1].y)

            let m = getLineCoeffients(startPoint: beginPoint, endPoint: finishPoint)

            let decimalX = pointPositionX - CGFloat(Int(pointPositionX))
            x = beginPoint.x + (finishPoint.x - beginPoint.x) * decimalX
            y = m.coefficient * x + m.offset
        } else {
            x = graphCGPoints[i].x
            y = graphCGPoints[i].y
        }

        var point = CGPoint(x: x, y: y)
        point.x -= circleDiameter / 2
        point.y -= circleDiameter / 2

        let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: circleDiameter, height: circleDiameter)))
        circle.fill()
    }
}



// MARK: - PointDataDelegate
extension PointView: PointDataDelegate {
    func setPointViewData(lineCoef: [LineCoefficients], graphCGPoints: [CGPoint]) {
        self.lineCoef = lineCoef
        self.graphCGPoints = graphCGPoints
    }
}
