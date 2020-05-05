//
//  GraphView.swift
//  GraphAndTable
//
//  Created by Maksim on 04/05/2020.
//  Copyright © 2020 Maksim. All rights reserved.
//

import UIKit


protocol PointDataDelegate: AnyObject {
    func setPointViewData(lineCoef: [LineCoefficients], graphCGPoints: [CGPoint])
}


@IBDesignable class GraphView: UIView {
    
    // MARK: - @IBInspectable
    @IBInspectable var startColor: UIColor = .red
    @IBInspectable var endColor: UIColor = .green
    
//    @IBInspectable var curveX1: CGFloat = 10
//    @IBInspectable var curveY1: CGFloat = 10
//    @IBInspectable var curveX2: CGFloat = 10
//    @IBInspectable var curveY2: CGFloat = 10
    
    
    weak var pointDataDelegate: PointDataDelegate?
    
    private struct Constants {
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let marginLeft: CGFloat = 20.0
        static let marginRight: CGFloat = 50
        static let topBorder: CGFloat = 60
        static let bottomBorder: CGFloat = 20
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 10.0
        static let numberOfLines = 4
    }
    
    var graphPointsY: [CGFloat] = [1, 6, 8, 4, 5, 7, 2, 4, 6]
    
    var lineCoef = [LineCoefficients]()
    var graphCGPoints = [CGPoint]()
    
    
    
    
    override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        
        // ----------- Draw Gradient ---------
        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColor.cgColor, endColor.cgColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: [])
        
        
        
        // ----------------- Set X ----------------
        let graphWidth = width - (Constants.marginLeft + Constants.marginRight) - 4
        let columnXPoint = { (column: Int) -> CGFloat in
            //Calculate the gap between points
            let spacing = graphWidth / CGFloat(self.graphPointsY.count - 1)
            return CGFloat(column) * spacing + Constants.marginLeft + 2
        }
        
        // ------------------ Set Y ----------------
        let topBorder = Constants.topBorder
        let bottomBorder = Constants.bottomBorder
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = graphPointsY.max()!
        let columnYPoint = { (graphPoint: CGFloat) -> CGFloat in
            let y = graphPoint / CGFloat(maxValue) * graphHeight
            return graphHeight + topBorder - y // Flip the graph
        }
        
        
        
        // ----------- Draw graph -----------
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        let graphPath = UIBezierPath()
        
        let currentPoint = CGPoint(x: columnXPoint(0), y: columnYPoint(graphPointsY[0]))
        graphPath.move(to: currentPoint)
        graphCGPoints.append(currentPoint)
        
        for i in 1..<graphPointsY.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPointsY[i]))
            graphPath.addLine(to: nextPoint)
            graphCGPoints.append(nextPoint)
        }
        
//        let graphPathCurve = UIBezierPath(curveFromPoints: graphCGPoints)!
        
        
        
        
        // ------- Create the clipping path for the graph gradient -----
        //save the state of the context
        context.saveGState()
        
        let clippingPath = graphPath.copy() as! UIBezierPath
        
        // lines to the copied path to complete the clip area
        clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPointsY.count - 1), y: height))
        clippingPath.addLine(to: CGPoint(x:columnXPoint(0), y:height))
        clippingPath.close()
        
        // add the clipping path to the context
        clippingPath.addClip()
        
        let highestYPoint = columnYPoint(maxValue)
        let graphStartPoint = CGPoint(x: 0, y: highestYPoint)
        let graphEndPoint = CGPoint(x: 0, y: bounds.height)
        
        context.drawLinearGradient(gradient, start: graphStartPoint, end: graphEndPoint, options: [])
        
        // Restore GState
        context.restoreGState()
        
        
        
        // ------ Draw the line on top of the clipped gradient ------
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
//        graphPathCurve.lineWidth = 2
//        graphPathCurve.stroke()
        
        
        // ------- Draw horizontal graph dotted lines on the top of everything
        let linePath = UIBezierPath()
        
        for i in 0...Constants.numberOfLines-1 {
            let size = CGFloat(i)/CGFloat(Constants.numberOfLines-1)
            linePath.move(to: CGPoint(x: Constants.marginLeft, y: graphHeight*size + topBorder))
            linePath.addLine(to: CGPoint(x: width - Constants.marginRight, y: graphHeight*size + topBorder))
        }
        
        let  dashes: [ CGFloat ] = [ 0.0, 12.0 ]
        linePath.setLineDash(dashes, count: dashes.count, phase: 0.0)
        linePath.lineWidth = 1
        linePath.lineCapStyle = .round
        UIColor.white.set()
        linePath.stroke()
        
        
        pointDataDelegate?.setPointViewData(lineCoef: lineCoef, graphCGPoints: graphCGPoints)

        
        
        
        
//        var point1 = CGPoint(x: curveX1, y: curveY1)
//        point1.x -= Constants.circleDiameter / 2
//        point1.y -= Constants.circleDiameter / 2
//
//        let circle = UIBezierPath(ovalIn: CGRect(origin: point1, size: CGSize(width: Constants.circleDiameter, height: Constants.circleDiameter)))
//        circle.fill()
//
//
//
//        var point2 = CGPoint(x: curveX2, y: curveY2)
//        point2.x -= Constants.circleDiameter / 2
//        point2.y -= Constants.circleDiameter / 2
//
//        let circle3 = UIBezierPath(ovalIn: CGRect(origin: point2, size: CGSize(width: Constants.circleDiameter, height: Constants.circleDiameter)))
//        circle3.fill()
    }
}

