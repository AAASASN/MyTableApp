//
//  ChangeEventHolderStatusTableViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 29.07.2022.
//

// Экран реализован при помощи UITableViewController с динамическими переиспользуемыми ячейками, используется кастомная ячейка ChangeEventHolderStatusCustomTableViewCell

import UIKit

class ChangeEventHolderStatusTableViewController: UITableViewController {

    // создадим константу для наполнения ячеек в таблице
    struct ContentForCustomCell {
        let status : EventHolderStatus
        let description : String
    }
    
    let tableContent = [ContentForCustomCell(status: .bestFriend, description: "fgdbvf fvdf  bvfdbgfbgb g bfgbfgbf gb bfffgbb"),
                        ContentForCustomCell(status: .colleague, description: "sd gf bbfgbgf gbfgbb bghfbf fgbg b bfgb fsf"),
                        ContentForCustomCell(status: .schoolFriend, description: "Вl,kijmuj mikmjjhnhg jngjnjm ngn ng  ngtnbtgyhby tyhtnа"),
                        ContentForCustomCell(status: .someFriend, description: "dff gff gfgdhg ghnn df"),
                        ContentForCustomCell(status: MyTableApp.EventHolderStatus.none, description: "Выбирайте этот статус если не можете определиться со статусом этого контакта"),]
    
    // в этой переменной будет храниться текущий статус
    var selectedStatus : EventHolderStatus = .none
    
    // обработчик выбора Статуса
    var doAfterStatusSelected: ((EventHolderStatus) -> Void)?
    
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
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // создаем экземпляь ячейки из кастомного типа ChangeEventHolderStatusCustomTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeEventHolderStatusCustomTableViewCellId") as! ChangeEventHolderStatusCustomTableViewCell
        
        // создаем экземпляр для хранения возможных вариантов наполнения ячейки и присваиваем ему именно то наполнение
        // которое нам нужно для конкретной ячейки с индексом indexPath.row
        let stringForEventHolderStatus : ContentForCustomCell = tableContent[indexPath.row]
        
        // наполняем лейблы ячейки данными
        cell.statusNameLabel.text = stringForEventHolderStatus.status.rawValue
        cell.statusDescriptionLabel.text = stringForEventHolderStatus.description
        
        // присваем в свойство .accessoryType значение свойства .checkmark  если self.selectedStatus равен статусу этой ячейки
        // self.selectedStatus при первом обращении всегда равно .none
        
        if selectedStatus == stringForEventHolderStatus.status {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // получаем значение выбранного(текущего) статуса
        let selectedStatus = tableContent[indexPath.row].status
        
        // вызов обработчика - передаем в замыкание doAfterStatusSelected значение типа
        // EventHolderStatus в зависимости от .row нажатой ячейки
        doAfterStatusSelected?(selectedStatus)
        
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
