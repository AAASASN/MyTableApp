//
//  AddEventHolderTableViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 18.07.2022.
//

import UIKit


class AddEventHolderTableViewController: UITableViewController {
    
    
    @IBOutlet weak var addFirstNameTextField: UITextField!
    @IBOutlet weak var addSecondNameTextField: UITextField!
    @IBOutlet weak var addEventHolderBirthdayDateTextField: UITextField!
    @IBOutlet weak var addEventHolderPhoneNumberTextField: UITextField!
    
    @IBOutlet weak var eventHolderSexLabel: UILabel!
    @IBOutlet weak var eventHolderStatusLabel: UILabel!
    
    var labelForCell6 = ""
    
    var eventHolderFirstName = String("введите имя")
    var eventHolderLastName = String("введите фамилию")
    var eventHolderBirthdayDate = String("какая-то дата")
    var eventHolderPhoneNumber: String = "введите номер или добавте из контактов"
    var sex: EventHolderSex = .none
    
    // переменная для хранения текущего статуса Юбиляра
    var currentEventHolderStatus: EventHolderStatus = .none
    
    // переменная для хранения текущего пола Юбиляра
    var currentEventHolderSex: EventHolderSex = .none
    
    var events: [EventProtocol] = []
    
    var doAfterEdit: ((String,
                       String,
                       String,
                       String,
                       Bool,
                       EventHolderStatus,
                       [EventProtocol]) -> Void)?
    
    // Словарь для eventHolderStatus
    private var statusTitles: [EventHolderStatus : String] = [
        .none : EventHolderStatus.none.rawValue,
        .bestFriend : EventHolderStatus.bestFriend.rawValue,
        .schoolFriend : EventHolderStatus.schoolFriend.rawValue,
        .colleague:  EventHolderStatus.colleague.rawValue,
        .someFriend : EventHolderStatus.someFriend.rawValue ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        addFirstNameTextField.text = eventHolderFirstName
//        addSecondNameTextField.text = eventHolderLastName
//        addEventHolderBirthdayDateTextField.text = eventHolderBirthdayDate
//        addEventHolderPhoneNumberTextField.text = eventHolderPhoneNumber
        
        eventHolderSexLabel.text = "Пол не выбран"
        // обновление метки eventHolderStatusLabel в соответствии текущим типом
        eventHolderStatusLabel?.text = statusTitles[currentEventHolderStatus]
        
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
    
    
    //    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    //        if indexPath.section == 0 && indexPath.row == 0 {
    //            let cell1 = tableView.dequeueReusableCell(withIdentifier: "AddFirstNameTableViewCellId") as! AddFirstNameTableViewCell
    //            //print("str - \(cell1.str)")
    //            eventHolderFirstName = cell1.str
    //            cell1.nameLabel.text = eventHolderFirstName
    //            print(eventHolderFirstName)
    //            tableView.reloadData()
    //        }
    //    }
    //
    
    
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
    
    // при переходе с экрана AddEventHolderTableViewController на ChangeEventHolderStatusTableViewController
    // при помощи сегвея с Id - "toChangeEventHolderStatusTableViewControllerId" реализуем передачу данных
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toChangeEventHolderStatusTableViewControllerId" {
            
            // ссылка на контроллер назначения
            let destination = segue.destination as! ChangeEventHolderStatusTableViewController
            
            // передача текущего статуса, при первом переходе статус всегда будет - .none
            destination.selectedStatus = currentEventHolderStatus
            
            // передача обработчика выбора статуса
            // doAfterStatusSelected является свойством-замыканием у которого есть тело-замыкание( тело функции),
            // передаем(присваеваем) ему это тело-реализацию функции, после этого в свойстве doAfterStatusSelected будет
            // храниться реализация замыкания(функции), и когда в будущем к этому свойству doAfterStatusSelected будут обращаться
            // функция будет выполняться
            destination.doAfterStatusSelected = { [self] selectedStatus in
                // изменяем статус пользователя в контроллере AddEventHolderTableViewController
                self.currentEventHolderStatus = selectedStatus
                // обновляем метку с текущим типом в AddEventHolderTableViewController
                eventHolderStatusLabel?.text = statusTitles[currentEventHolderStatus]
                
                // таким образом мы выполнили операции в AddEventHolderTableViewController при помощи замыкания doAfterStatusSelected вызвав его
                // вообще в другом контроллере
                
            }
        }
        
        if segue.identifier == "toChangeEventHolderSexTableViewControllerId" {
            let destination = segue.destination as! ChangeEventHolderSexTableViewController
            destination.selectedSex = currentEventHolderSex
            destination.doAfterSexSelected = {[self] selectedSex in
                self.currentEventHolderSex = selectedSex
                eventHolderSexLabel.text = currentEventHolderSex.rawValue
            }
        }
    }
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        if indexPath.section == 0 && indexPath.row == 2 {
    //
    //            let cell = tableView.dequeueReusableCell(withIdentifier: "AddDateTableViewCellId", for: indexPath) as! AddDateTableViewCell
    //
    //        }
    
    
    
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
    //  }
    
}
