//
//  SelectEventTypeTableViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 28.08.2022.
//

import UIKit

class SelectEventTypeTableViewController: UITableViewController {

    // замыкание для передачи информации о выбраном поле на предыдущий экран в иерархии Навигейшен контроллера
    var doAfterEventTypeSelected : ((EventType) -> Void)?
    
    // в этой переменной будет храниться текущий тип события
    var selectedEventType : EventType = .none
   
    
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Выберите тип события"
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "в будущем варианты возможно будут расширены..."
    }

    
    // действия при нажатии на ячейку
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        let numberOfRows = tableView.numberOfRows(inSection: section)

        // пройдемся циклом по всем  ячейкам секции для того что бы убрать галку .checkmark
        // там где не нужно и поставить там где нужно
        for row in 0..<numberOfRows {
            if let cell = tableView.cellForRow(at: NSIndexPath(row: row, section: section) as IndexPath) {
                cell.accessoryType = .none
                if indexPath.row == row {
                    switch row {
                    case 0 :
                        selectedEventType = .birthday
                        cell.accessoryType = .checkmark
                    case 1 :
                        selectedEventType = .birthOfChildren
                        cell.accessoryType = .checkmark
                    case 2 :
                        selectedEventType = .wedding
                        cell.accessoryType = .checkmark
                    case 3 :
                        selectedEventType = .housewarming
                        cell.accessoryType = .checkmark
                    default:
                        selectedEventType = .none
                        cell.accessoryType = .checkmark
                    }
                }
            }
        }
        
        // вызов обработчика - передаем в замыкание doAfterSexSelected значение типа
        // selectedSex в зависимости от .row нажатой ячейки
        doAfterEventTypeSelected?(selectedEventType)
        
        // переход к предыдущему экрану осуществляется средствами  UINavigationController котовый при помощи метода popViewController() и
        // возвращает последний UIViewController(или UITableViewController) в массиве контроллеров хранящихся в в самОм навигейшен контороллере
        // им и является UITableViewController из предыдушего экрана ( .navigationController это свойство текущего UIViewController(или UITableViewController)
        // которыое по сути является делегатом UINavigationController в UIViewController(или UITableViewController))
        navigationController?.popViewController(animated: true)
    }
    
    // этот метод позволяет настроить ячейки перед отображением
    // перед отображением проверяем значение в selectedEventType - это пол переданый
    // с предыдущего экрана при переходе по сигвею и устанавливаем галочку .checkmark
    // в соответствующую ячейку
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let eventTypeEnumContentArray = EventType.allCases //[EventType.birthday, .birthOfChildren, .housewarming, .wedding, .none]
        for _ in eventTypeEnumContentArray {
            if eventTypeEnumContentArray[indexPath.row] == selectedEventType {
                cell.accessoryType = .checkmark
            }
        }
    }
}
