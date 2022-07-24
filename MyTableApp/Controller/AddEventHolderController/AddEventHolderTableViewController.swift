//
//  AddEventHolderTableViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 18.07.2022.
//

import UIKit


class AddEventHolderTableViewController: UITableViewController {
    
    var labelForCell6 = ""
    
    var eventHolderFirstName = String("")
    var eventHolderLastName = String("введите фамилию")
    var eventHolderStatus: EventHolderStatus = .none
    var events: [EventProtocol] = []
    var eventHolderPhoneNumber: String = "введите номер или добавте из контактов"
    var sex: Bool = true


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
        if section == 0 { return 6 } else { return 1 }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "AddFirstNameTableViewCellId", for: indexPath) as! AddFirstNameTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "AddSecondNameTableViewCellId", for: indexPath) as! AddSecondNameTableViewCell
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "AddDateTableViewCellId", for: indexPath) as! AddDateTableViewCell
        let cell4 = tableView.dequeueReusableCell(withIdentifier: "AddSexTableViewCellId", for: indexPath) as! AddSexTableViewCell
        let cell5 = tableView.dequeueReusableCell(withIdentifier: "AddPhoneNumberTableViewCellId", for: indexPath) as! AddPhoneNumberTableViewCell
        let cell6 = tableView.dequeueReusableCell(withIdentifier: "AddStatusEventHolderTableViewCellId", for: indexPath) as! AddStatusEventHolderTableViewCell
        let cell7 = tableView.dequeueReusableCell(withIdentifier: "AddEventTableViewCellId", for: indexPath) as! AddEventTableViewCell
        
        switch indexPath.section {
            
        case 0: do {
            switch indexPath.row {
            case 0:
                cell1.nameField.text = eventHolderFirstName;
                return cell1
            case 1: cell2.textLabel?.text = ""; return cell2
            case 2: cell3.textLabel?.text = ""; return cell3
            case 3: cell4.textLabel?.text = ""; return cell4
            case 4: cell5.textLabel?.text = ""; return cell5
            case 5: cell6.textLabel?.text = labelForCell6; return cell6
            default: print("section_0 Error")
            }
        }
            
            
            
            
        case 1: do {
            switch indexPath.row {
            case 0: cell7.textLabel?.text = "здесь будут отображаться события"; return cell7
            default:
                print("section_1 Error")
            }
        }
            
        default: print("section_0_1 Error")
        }
        return cell1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Заполните данные о юбиляре"
        } else {
            return "Праздники и события"
        }
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "AddFirstNameTableViewCellId") as! AddFirstNameTableViewCell
            //print("str - \(cell1.str)")
            eventHolderFirstName = cell1.str
            cell1.nameField.text = eventHolderFirstName
            print(eventHolderFirstName)
            tableView.reloadData()
        }
    }
    
    // не работает
    @IBAction func saveNewEventHolder(_ sender: UIBarButtonItem) {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "AddFirstNameTableViewCellId") as! AddFirstNameTableViewCell

        tableView.reloadData()
        
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddDateTableViewCellId", for: indexPath) as! AddDateTableViewCell
            
        }
        
        
        
//        if indexPath.section == 0 && indexPath.row == 5 {
//
//            let statusCell = tableView.dequeueReusableCell(withIdentifier: "AddStatusEventHolderTableViewCellId", for: indexPath) as! AddStatusEventHolderTableViewCell
//
//            let alert = UIAlertController(title: "Выберите пол", message: nil, preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
//                print("нажато ДА")
//                self.labelForCell6 = "Что то было выбрано"
//                //statusCell.statusLabel.text = "Что то было выбрано"
//
//            }))
//
//            alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: nil))
//
//            self.present(alert, animated: true)
//
//        }
    }
    
}
