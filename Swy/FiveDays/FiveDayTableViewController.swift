//
//  FiveDayTableViewController.swift
//  Swy
//
//  Created by Николай Великанец on 13.09.17.
//  Copyright © 2017 RockinHat. All rights reserved.
//

import UIKit
import FSLineChart

class FiveDayTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var forecast = [Weather]()
    
    @IBOutlet weak var lineChartVeiw: FSLineChart!
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
    
   /*  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //print(valueArrayForCell[indexPath.row])
        print(forecast[indexPath.row])
        
    }*/
 
    @IBAction func SaveData(_ sender: Any) {
        
        let cDataManager = CoreDataManager()
        cDataManager.saveData(weatherToSave: forecast)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ForSavedDataTableViewController = storyboard.instantiateViewController(withIdentifier: "SavedTable") as! SavedTableViewController
        ForSavedDataTableViewController.modalTransitionStyle = .coverVertical
        self.present(ForSavedDataTableViewController, animated: true, completion: nil)
    }
    func drawGraph(){
        var temperatureArr = [Double]()
        for temp in forecast {
            temperatureArr.append(temp.measurement.temp)
        }
     
        lineChartVeiw.verticalGridStep = 7
        lineChartVeiw.horizontalGridStep = 9
       // lineChartVeiw.labelForIndex = { "\($0)" }
        lineChartVeiw.labelForValue = { "\(Int($0))" }
        lineChartVeiw.setChartData(temperatureArr)
        //scrollVewForGraoh.addSubview(lineChartVeiw)
        scrollVewForGraoh.contentSize = CGSize(width: lineChartVeiw.frame.width, height: scrollVewForGraoh.frame.height)
    }
}
