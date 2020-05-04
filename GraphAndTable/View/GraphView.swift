//
//  GraphView.swift
//  GraphAndTable
//
//  Created by Maksim on 04/05/2020.
//  Copyright © 2020 Maksim. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIView {
    
    @IBInspectable var startColor: UIColor = .red
    @IBInspectable var endColor: UIColor = .green
    
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
    
    struct LineCoefficients {
        var coefficient: CGFloat
        var offset: CGFloat
    }
    
    var graphPoints = [4, 2, 6, 4, 5, 8, 3, 1, 5, 6, 7, 3 , 12, 4, 2, 6]
    var pointPositionX: CGFloat = 0
    
    var lineCoef = [LineCoefficients]()
    
    
//    func populateLineCoeffients(startPoint: CGPoint, endPoint: CGPoint) {
//        let coefficient = CGFloat((endPoint.y - startPoint.y) / (endPoint.x - startPoint.x))
//        let offset = endPoint.y - coefficient * endPoint.x
//        lineCoef.append(LineCoefficients(coefficient: coefficient, offset: offset))
//    }
    
    func getLineCoeffients(startPoint: CGPoint, endPoint: CGPoint) -> LineCoefficients {
        let coefficient = CGFloat((endPoint.y - startPoint.y) / (endPoint.x - startPoint.x))
        let offset = endPoint.y - coefficient * endPoint.x
        return LineCoefficients(coefficient: coefficient, offset: offset)
    }
    
    
    override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        
        // ------- Draw Gradient
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
        
        
        
        // ------- Set X
        let graphWidth = width - (Constants.marginLeft + Constants.marginRight) - 4
        let columnXPoint = { (column: Int) -> CGFloat in
            //Calculate the gap between points
            let spacing = graphWidth / CGFloat(self.graphPoints.count - 1)
            return CGFloat(column) * spacing + Constants.marginLeft + 2
        }
        
        // ------- Set Y
        let topBorder = Constants.topBorder
        let bottomBorder = Constants.bottomBorder
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = graphPoints.max()!
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
            let y = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            return graphHeight + topBorder - y // Flip the graph
        }
        
        
        
        
        
        // ------- Draw graph
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        // set up the points line
        let graphPath = UIBezierPath()
        
        // go to start of line
        var currentPoint = CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0]))
        graphPath.move(to: currentPoint)
        
        // add points for each item in the graphPoints array
        // at the correct (x, y) for the point
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
            
//            populateLineCoeffients(startPoint: currentPoint, endPoint: nextPoint)
//            currentPoint = nextPoint
        }
        
        
        
        
        
        // ------- Create the clipping path for the graph gradient
        //1 - save the state of the context (commented out for now)
        context.saveGState()
        
        //2 - make a copy of the path
        let clippingPath = graphPath.copy() as! UIBezierPath
        
        //3 - add lines to the copied path to complete the clip area
        clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints.count - 1), y: height))
        clippingPath.addLine(to: CGPoint(x:columnXPoint(0), y:height))
        clippingPath.close()
        
        //4 - add the clipping path to the context
        clippingPath.addClip()
        
        let highestYPoint = columnYPoint(maxValue)
        let graphStartPoint = CGPoint(x: 0, y: highestYPoint)
        let graphEndPoint = CGPoint(x: 0, y: bounds.height)
        
        context.drawLinearGradient(gradient, start: graphStartPoint, end: graphEndPoint, options: [])
        
        // Restore GState
        context.restoreGState()
        
        
        
        // ------- Draw the line on top of the clipped gradient
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        
          
        
        
        // ------- Draw horizontal graph lines on the top of everything
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
        
        
        
       // ------- Draw the circles on top of the graph stroke
//        for i in 0..<graphPoints.count {
//          var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
//          point.x -= Constants.circleDiameter / 2
//          point.y -= Constants.circleDiameter / 2
//
//          let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: Constants.circleDiameter, height: Constants.circleDiameter)))
//          circle.fill()
//        }
        
        
        // ------- Draw individual point
//        var point = CGPoint(x: columnXPoint(pointPositionX), y: columnYPoint(graphPoints[pointPositionX]))
//        point.x -= Constants.circleDiameter / 2
//        point.y -= Constants.circleDiameter / 2
//
//        let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: Constants.circleDiameter, height: Constants.circleDiameter)))
//        circle.fill()
        
        let x: CGFloat
        let y: CGFloat
        
        let i = Int(pointPositionX)
        if i < graphPoints.count - 1 {
            let i = Int(pointPositionX)
            let beginPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            let finishPoint = CGPoint(x: columnXPoint(i+1), y: columnYPoint(graphPoints[i+1]))
            
            let m = getLineCoeffients(startPoint: beginPoint, endPoint: finishPoint)
            
            let decimalX = pointPositionX - CGFloat(Int(pointPositionX))
            x = beginPoint.x + (finishPoint.x - beginPoint.x) * decimalX
            y = m.coefficient * x + m.offset
        } else {
            x = columnXPoint(i)
            y = columnYPoint(graphPoints[i])
        }
        
        var point = CGPoint(x: x, y: y)
        point.x -= Constants.circleDiameter / 2
        point.y -= Constants.circleDiameter / 2

        let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: Constants.circleDiameter, height: Constants.circleDiameter)))
        circle.fill()
    }
}

