//
//  TableViewController.swift
//  Quick Search
//
//  Created by Ruben van Breda on 2020/09/14.
//  Copyright © 2020 Ruben van Breda. All rights reserved.
//

import UIKit

struct MY_ML_Model{
    var name: String
    var image : UIImage
}
class TableViewController: UITableViewController {

    var my_models : [MY_ML_Model] = [MY_ML_Model(name: "Defualt",image: UIImage(named: "misc")!),MY_ML_Model(name: "Flowers", image: UIImage(named: "flower")!),MY_ML_Model(name: "Birds",image: UIImage(named: "bird")!),MY_ML_Model(name: "Vehicle",image: UIImage(named: "car")!),MY_ML_Model(name: "Food",image: UIImage(named: "food")!)]
    var current_model : MY_ML_Model = MY_ML_Model(name: "",image: UIImage(named: "flower")!)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

    
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped \(my_models[indexPath.row].name)")
        current_model = my_models[indexPath.row]
        print("Current Model on cell tap \(current_model.name)")
        performSegue(withIdentifier: "MainView", sender: self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return my_models.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let cellName = my_models[indexPath.row].name
    
        cell.textLabel?.text = "\(cellName)"
        cell.imageView?.image = my_models[indexPath.row].image

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        var vc = segue.destination as! ViewController
        
        // Pass the selected object to the new view controller.
        vc.model_to_use.name = current_model.name
    }
    

}
