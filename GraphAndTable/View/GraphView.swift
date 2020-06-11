//
//  GraphView.swift
//  GraphAndTable
//
//  Created by Maksim on 04/05/2020.
//  Copyright © 2020 Maksim. All rights reserved.
//

import UIKit


protocol PointDataDelegate: AnyObject {
    func setPointViewData(graphCGPoints: [CGPoint])
}


@IBDesignable class GraphView: UIView {
    
    // MARK: - @IBInspectable
    @IBInspectable var startColour: UIColor = .red
    @IBInspectable var endColour: UIColor = .green
    @IBInspectable var lineColour: UIColor = .purple
    
    @IBInspectable var marginLeft: CGFloat = 20.0
    @IBInspectable var marginRight: CGFloat = 50
    
    
    weak var pointDataDelegate: PointDataDelegate?
    
    private struct Constants {
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let topBorder: CGFloat = 60
        static let bottomBorder: CGFloat = 5
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 10.0
        static let numberOfLines = 4
    }
    
    var graphPointsY: [CGFloat] = [0, 6, 8, 4, 5, 7, 2, 4, 6, 8] // fill to see in storyboard
    
    
    
    
    
    override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        
        // ----------- Draw Gradient ---------
        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColour.cgColor, endColour.cgColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        
//        let startPoint = CGPoint.zero
//        let endPoint = CGPoint(x: 0, y: bounds.height)
//        context.drawLinearGradient(gradient,
//                                   start: startPoint,
//                                   end: endPoint,
//                                   options: [])
        
        
        
        // ----------------- Set X ----------------
        let graphWidth = width - (marginLeft + marginRight) - 4
        let columnXPoint = { (column: Int) -> CGFloat in
            //Calculate the gap between points
            let spacing = graphWidth / CGFloat(self.graphPointsY.count - 1)
            return CGFloat(column) * spacing + self.marginLeft + 2
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
        
        
    
        
        // ------------- Generate points --------------
        var graphCGPoints = [CGPoint]()
        for i in 0..<graphPointsY.count {
            graphCGPoints.append(CGPoint(x: columnXPoint(i), y: columnYPoint(graphPointsY[i])))
        }
        pointDataDelegate?.setPointViewData(graphCGPoints: graphCGPoints)
        
        
        
        
        // ----------- Draw graph -----------
        lineColour.setFill()
        lineColour.setStroke()
        
        let graphPath = UIBezierPath(curveFromPoints: graphCGPoints)!
        
        
        
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
        
        
        
        // ------- Draw horizontal graph dotted lines on the top of everything
        let linePath = UIBezierPath()
        
        for i in 0...Constants.numberOfLines-1 {
            let size = CGFloat(i)/CGFloat(Constants.numberOfLines-1)
            linePath.move(to: CGPoint(x: marginLeft, y: graphHeight*size + topBorder))
            linePath.addLine(to: CGPoint(x: width - marginRight, y: graphHeight*size + topBorder))
        }
        
        let  dashes: [ CGFloat ] = [ 0.0, 12.0 ]
        linePath.setLineDash(dashes, count: dashes.count, phase: 0.0)
        linePath.lineWidth = 1
        linePath.lineCapStyle = .round
        UIColor.purple.set()
        linePath.stroke()
        
        
    }
}

