//
//  ShowAllEventsOfSomeHolderTableViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 01.09.2022.
//

import UIKit

class ShowAllEventsOfSomeHolderTableViewController: UITableViewController {

    var events: [EventProtocol] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return events.count
        } else { return 1 }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellForReturn = UITableViewCell()
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "OneEventSomeHolderTableViewCellID", for: indexPath) as! OneEventSomeHolderTableViewCell
        cell1.eventTypeLabel.text = events[indexPath.row].eventType.rawValue
        cell1.isActualLabel.text = events[indexPath.row].isActual == true ? "Актуально" : "Не актуально"
        
        print("в event \(events[indexPath.row].eventDiscription)")
        cell1.eventDiscriptionLabel.text = events[indexPath.row].eventDiscription
        print("в label \((cell1.eventDiscriptionLabel.text ?? "error"))")

        cell1.dayCountLabel.text = String(events[indexPath.row].eventDate.daysCountBeforeEvent)
        cell1.eventDateLabel.text = events[indexPath.row].eventDate.dateAsString
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "AddEventButtonTableViewCellID", for: indexPath) as! AddEventButtonTableViewCell
        
        // Configure the cell...
        if indexPath.section == 0 {
            cellForReturn = cell1
        } else if indexPath.section == 1 {
            return cell2
        }
        return cellForReturn
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
