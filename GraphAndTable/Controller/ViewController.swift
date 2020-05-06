//
//  ViewController.swift
//  GraphAndTable
//
//  Created by Maksim on 04/05/2020.
//  Copyright © 2020 Maksim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var maxValue: UILabel!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var pointView: PointView!
    @IBOutlet weak var tableView: UITableView!
    
    var pointPositionX: CGFloat = 0
    var graphCGPoints = [CGPoint]()
    let rowHeight: CGFloat = 70
    
    let prices: [CGFloat] = [6, 15, 26, 13, 5, 23, 16, 17, 18, 11, 9, 10, 24, 17, 1, 15, 13, 14, 5, 8, 9, 10, 15, 28, 14, 13]
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        graphView.pointDataDelegate = pointView
        graphView.graphPointsY = prices
        
        pointView.pointPositionX = CGFloat(prices.count-1)
        maxValue.text = "£\(prices.max()!)"
    }

}


// MARK: - TableView Extension
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = "Title Sample Info"
        cell.detailTextLabel?.text = "£\(prices[indexPath.row])"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y < 0) { return }
        
        let row = CGFloat(prices.count-1) - scrollView.contentOffset.y / rowHeight
        if (row < 0) { return }
        
        pointView.pointPositionX = CGFloat(row)
        pointView.setNeedsDisplay()
    }
}

