//
//  ShowAllEventsOfSomeHolderTableViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 01.09.2022.
//

import UIKit

class ShowAllEventsOfSomeHolderTableViewController: UITableViewController {

    // свойство для загрузки в него хранилища с данными
    var eventsStorage : EventStorageProtocol = EventStorage()
    
    var currentEventsHolder : EventHolder!
    var events: [EventProtocol] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // получим актуальный список [EventHolder] в хранилище eventsStorage
        eventsStorage.getUpdatedDataToEventStorage()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        // получим актуальный список [EventHolder] в хранилище eventsStorage
        eventsStorage.getUpdatedDataToEventStorage()
        //
        // обновим таблицу перед отображением
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        var cellForReturn = UITableViewCell()
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "OneEventSomeHolderTableViewCellID", for: indexPath) as! OneEventSomeHolderTableViewCell
        cell1.eventTypeLabel.text = events[indexPath.row].eventType.rawValue
        cell1.isActualLabel.text = events[indexPath.row].isActual == true ? "Актуально" : "Не актуально"
        cell1.eventDiscriptionLabel.text = events[indexPath.row].eventDiscription
        cell1.dayCountLabel.text = String(events[indexPath.row].eventDate.daysCountBeforeEvent)
        cell1.eventDateLabel.text = events[indexPath.row].eventDate.dateAsString

        if indexPath.section == 0 {
            cellForReturn = cell1
        }
        return cellForReturn
    }
    
        // Вывод заголовка в секцию
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "События \(currentEventsHolder.eventHolderFirstName) \(currentEventsHolder.eventHolderLastName)"
        }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
              if editingStyle == .delete {
                  // Delete the row from the data source
                  events.remove(at: indexPath.row)
                  tableView.deleteRows(at: [indexPath], with: .fade)
                  tableView.reloadData()
                  
                  self.navigationController?.viewControllers.forEach{ viewController in
                      (viewController as? AddEventHolderTableViewController)?.eventHolder.events.remove(at: indexPath.row)
                      let eventCount = (viewController as? AddEventHolderTableViewController)?.eventHolder.events.count
                      (viewController as? AddEventHolderTableViewController)?.eventCountLabel.text =  String(eventCount ?? 9999)
                      (viewController as? AddEventHolderTableViewController)?.tableView.reloadData()

                  }
              } else if editingStyle == .insert {
                  // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
              }
        }

    }
    

//    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toEditEventTableViewControllerID" {
//            // ссылка на контроллер назначения
//            let destination = segue.destination as! EditEventTableViewController
//            destination.oneEvent = events[indexPath.row] as! Event
//            }
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // получаем вью контроллер, в который происходит переход
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editScreen = storyboard.instantiateViewController(withIdentifier: "EditEventTableViewControllerID") as! EditEventTableViewController
        // передаем данные
        editScreen.oneEvent = events[indexPath.row] as! Event
        // переходим к следующему экрану
        self.navigationController?.pushViewController(editScreen , animated: true)
        // toEditEventTableViewControllerID
    }

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

  
     //MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddEventTableViewControllerID" {
            let destination = segue.destination as! AddEventTableViewController
            destination.currentEventsHolder = self.currentEventsHolder
        }
    }
 

    
}
