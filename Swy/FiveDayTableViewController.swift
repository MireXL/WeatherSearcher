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
        DrawGraph()
        
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
    
    func DrawGraph(){
        var temperatureArr = [Int]()
        var path = 12
        for temp in forecast {
            temperatureArr.append(Int(temp.measurement.temp))
        }
        guard let maxTemp = temperatureArr.max(),
            let minTemp = temperatureArr.min() else {return}
        let multiplierForMax = Int((Int(scrollVewForGraoh.frame.height)/maxTemp))
        let multiplierForMin = Int((Int(scrollVewForGraoh.frame.height)/minTemp))
        var graphMultiplier = Int()
        var yAxis = Int()
        if multiplierForMin < multiplierForMax && multiplierForMin > 0 {
            
            graphMultiplier = multiplierForMin - 1
            
        } else  if -multiplierForMin < multiplierForMax &&  multiplierForMin < 0{
            graphMultiplier = -(multiplierForMin-1)/2
            
        } else  if multiplierForMin < multiplierForMax &&  multiplierForMin < 0{
            graphMultiplier = (multiplierForMax-1)/2
            
        }else {
            
            graphMultiplier = multiplierForMax - 1
        }
        print(graphMultiplier)
        if minTemp < 0 {
            
            for temp in temperatureArr{
                let line = CAShapeLayer()
                let linePath = UIBezierPath()
                linePath.move(to: CGPoint(x:path, y:Int(scrollVewForGraoh.frame.height/2)))
                let codedLabel:UILabel = UILabel()
                if temp < 0 {
                    
                    if (Int(scrollVewForGraoh.frame.height/2) - Int(temp)*graphMultiplier) > Int(scrollVewForGraoh.frame.height) {
                        yAxis = Int(scrollVewForGraoh.frame.height)
                    }else {
                        
                        yAxis = Int(scrollVewForGraoh.frame.height/2)-Int(temp)*graphMultiplier
                    }
                    line.strokeColor = UIColor(red:90/255, green: 200/255, blue: 250/255, alpha: 1).cgColor
                    
                    codedLabel.frame = CGRect(x: path - 12, y: Int(scrollVewForGraoh.frame.height/2) - 21 , width: 21, height: 21)
                    codedLabel.text = "\(temp)"
                }else{
                    
                    if Int(scrollVewForGraoh.frame.height) - temp*graphMultiplier > Int(scrollVewForGraoh.frame.height) {
                        yAxis = 20
                    }else {
                        
                        yAxis = Int(scrollVewForGraoh.frame.height/2) - temp*graphMultiplier
                    }
                    
                    line.strokeColor = UIColor(red:255/255, green: 217/255, blue: 48/255, alpha: 1).cgColor
                    
                    codedLabel.frame = CGRect(x: path - 10, y:Int(scrollVewForGraoh.frame.height/2), width: 21, height: 21)
                    codedLabel.text = "\(temp)"
                }
                linePath.addLine(to: CGPoint(x: path, y:yAxis))
                line.path = linePath.cgPath
                line.lineWidth = 15
                line.lineJoin = kCALineJoinRound
                scrollVewForGraoh.layer.addSublayer(line)
                
                codedLabel.textAlignment = .center
                codedLabel.numberOfLines=1
                codedLabel.textColor=UIColor.black
                codedLabel.font=UIFont.systemFont(ofSize: 10)
                scrollVewForGraoh.addSubview(codedLabel)
                path += 23
            }
        }else {
            
            for temp in temperatureArr{
                
                let line = CAShapeLayer()
                let linePath = UIBezierPath()
                linePath.move(to: CGPoint(x: path, y:Int(scrollVewForGraoh.frame.height) - 21))
                if Int(scrollVewForGraoh.frame.height) - temp*graphMultiplier > Int(scrollVewForGraoh.frame.height) {
                    yAxis = 20
                }else {
                    yAxis = Int(scrollVewForGraoh.frame.height) - temp*graphMultiplier
                }
                linePath.addLine(to: CGPoint(x: path, y:yAxis))
                line.path = linePath.cgPath
                line.strokeColor = UIColor(red:255/255, green: 217/255, blue: 48/255, alpha: 1).cgColor
                line.lineWidth = 15
                line.lineJoin = kCALineJoinRound
                scrollVewForGraoh.layer.addSublayer(line)
                
                let codedLabel:UILabel = UILabel()
                codedLabel.frame = CGRect(x: path - 10, y: Int(scrollVewForGraoh.frame.height)-21 , width: 21, height: 21)
                codedLabel.textAlignment = .center
                codedLabel.text = "\(temp)"
                codedLabel.numberOfLines=1
                codedLabel.textColor=UIColor.black
                codedLabel.font=UIFont.systemFont(ofSize: 10)
                scrollVewForGraoh.addSubview(codedLabel)
                
                path += 23
            }
        }
        scrollVewForGraoh.contentSize = CGSize(width: path, height: 128)
    }
}
