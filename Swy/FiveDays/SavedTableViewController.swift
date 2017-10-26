//
//  SavedTableViewController.swift
//  Swy
//
//  Created by Николай Великанец on 25.10.2017.
//  Copyright © 2017 RockinHat. All rights reserved.
//

import UIKit

class SavedTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var forecaster = [DataForecast]()
    @IBOutlet weak var tableViewForDate: UITableView!
    override func viewDidLoad() {
        let cDataManger = CoreDataManager()
       forecaster = cDataManger.fetchDateHour()
        print(forecaster.count)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return forecaster.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "Cellys", for: indexPath)
        cell.textLabel?.text = forecaster[indexPath.row].value(forKeyPath: "dateAndHour") as? String
    
        return(cell)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let date = forecaster[indexPath.row].value(forKeyPath: "dateAndHour") as? String else {return}
        print(date)
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let fiveDaysSavedDate = storyboard.instantiateViewController(withIdentifier: "FiveDaysSavedVC") as! FiveDaysSavedDataVC
        fiveDaysSavedDate.DateForFetch = date
        self.present(fiveDaysSavedDate, animated: true, completion: nil)  
    }

     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let cDataManager = CoreDataManager()
            let deleted =  cDataManager.deleteData(dataToDelete: forecaster[indexPath.row])
            if deleted == true{
                print("deleted \(forecaster[indexPath.row])")
                forecaster.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with:.automatic)
                tableView.reloadData()
            }else {
                print("Error")
            }
            
        }
    }

    

}
