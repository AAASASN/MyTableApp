//
//  ChangeEventHolderSexTableViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 31.07.2022.
//

import UIKit

class ChangeEventHolderSexTableViewController: UITableViewController {

    //var currentSelectedSex : Bool?

    // замыкание для передачи информации о выбраном поле на предыдущий экран в иерархии Навигейшен контроллера
    var doAfterSexSelected : ((EventHolderSex) -> Void)?
    
    // в этой переменной будет храниться текущий пол
    var selectedSex : EventHolderSex = .none
    
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
        
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Выберите пол юбиляра"
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "в будущем варианты выбора пола будут расширены... возможно"
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeEventHolderSexCustomTableViewCellId") as! ChangeEventHolderSexCustomTableViewCell
//
//        cell.accessoryType = .checkmark
//
//        return cell
//    }

    // действия при нажатии на ячейку
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        let numberOfRows = tableView.numberOfRows(inSection: section)
        for row in 0..<numberOfRows {
            
            if let cell = tableView.cellForRow(at: NSIndexPath(row: row, section: section) as IndexPath) {
                cell.accessoryType = .none
                if indexPath.row == row {
                    
                    switch row {
                    case 0 :
                        selectedSex = .male
                        cell.accessoryType = .checkmark
                    case 1 :
                        selectedSex = .female
                        cell.accessoryType = .checkmark
                    case 2 :
                        selectedSex = .third
                        cell.accessoryType = .checkmark
                    default:
                        selectedSex = .none
                        cell.accessoryType = .checkmark
                    }
                    // вызываем
                    doAfterSexSelected?(selectedSex)
                    
                }
            }
        }
        
//        // получаем значение выбранного(текущего) статуса
//        let selectedStatus = tableContent[indexPath.row].status
        
//        // вызов обработчика - передаем в замыкание doAfterStatusSelected значение типа
//        // EventHolderStatus в зависимости от .row нажатой ячейки
//        doAfterStatusSelected?(selectedStatus)
        
        // переход к предыдущему экрану осуществляется средствами  UINavigationController котовый при помощи метода popViewController()
        // возвращает последний UIViewController(или UITableViewController) в массиве контроллеров хранящихся в в самОм навигейшен контороллере
        // им и является UITableViewController из предыдушего экрана
        navigationController?.popViewController(animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
    

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

    // этот метод позволяет настроить ячейки перед отображением
    // перед отображением проверяем значение в selectedSex - это пол пеереданый
    // с предыдущего экрана при переходе по сигвею и устанавливаем галочку .checkmark
    // в соответствующую ячейку
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let sexEnumContentArray = [EventHolderSex.male, .female, .third, .none]
        for _ in sexEnumContentArray {
            if sexEnumContentArray[indexPath.row] == selectedSex {
                cell.accessoryType = .checkmark
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
