//
//  FiveDayTableViewController.swift
//  Swy
//
//  Created by Николай Великанец on 13.09.17.
//  Copyright © 2017 RockinHat. All rights reserved.
//

import UIKit

class FiveDayTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var forecast = [Weather]()
    
    @IBOutlet weak var scrollVewForGraoh: UIScrollView!
    
    // @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var fiveDaysTableView: UITableView!
    
    override func viewDidLoad() {
        
        self.fiveDaysTableView.rowHeight = UITableViewAutomaticDimension
        self.fiveDaysTableView.estimatedRowHeight = 400
        drawGraph()
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return forecast.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellFive", for: indexPath) as? FiveDaysTableViewCell  else {
            return  UITableViewCell()
        }
        cell.cellFillFunc(cellFiller: forecast[indexPath.row])
        return(cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //print(valueArrayForCell[indexPath.row])
    }
    
    func drawGraph(){
        let graphDraw = GraphDraw()
        let points = graphDraw.drawGraphFunc(forecast: forecast, viewHeight: Int(scrollVewForGraoh.frame.height))
        guard let min = points.temp.min() else {return}

        for i in 0..<points.x.count{
            let codedLabel:UILabel = UILabel()
            codedLabel.frame.size = CGSize(width: 21, height: 21)
            codedLabel.center.x = CGFloat(points.x[i])
            let line = CAShapeLayer()
            let linePath = UIBezierPath()
            if min < 0 {
                linePath.move(to: CGPoint(x: points.x[i], y:Int(scrollVewForGraoh.frame.height/2)))
                if points.temp[i] < 0 {
                    
                    line.strokeColor = UIColor.lightBlue.cgColor
                    codedLabel.center.y = CGFloat(scrollVewForGraoh.frame.height/2 - codedLabel.frame.width/2)
                } else {
                    
                    line.strokeColor = UIColor.sunnyYellow.cgColor
                    codedLabel.center.y = CGFloat(scrollVewForGraoh.frame.height/2 + codedLabel.frame.width/2)
                }      
            }else{
                
                linePath.move(to: CGPoint(x: points.x[i], y:Int(scrollVewForGraoh.frame.height) - 21))
                line.strokeColor = UIColor.sunnyYellow.cgColor
                codedLabel.center.y = CGFloat(scrollVewForGraoh.frame.height - codedLabel.frame.width/2)
                
            }
            
            linePath.addLine(to: CGPoint(x: points.x[i], y:points.y[i]))
            line.path = linePath.cgPath
            line.lineWidth = 21
            line.lineJoin = kCALineJoinRound
            scrollVewForGraoh.layer.addSublayer(line)
            
            codedLabel.textAlignment = .center
            codedLabel.text = "\(points.temp[i])"
            codedLabel.numberOfLines=0
            codedLabel.textColor=UIColor.black
            codedLabel.font=UIFont.systemFont(ofSize: 10)
            scrollVewForGraoh.addSubview(codedLabel)
            
        }
        scrollVewForGraoh.contentSize = CGSize(width: points.x[points.x.endIndex-1] + 15, height: 128)
    }
}
