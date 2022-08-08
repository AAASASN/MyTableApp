//
//  ChangeEventHolderSexTableViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 31.07.2022.
//


// Экран реализован при помощи UITableViewController с использованием статических ячеек


import UIKit

class ChangeEventHolderSexTableViewController: UITableViewController {
    
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
                }
            }
        }
        
        // вызов обработчика - передаем в замыкание doAfterSexSelected значение типа
        // selectedSex в зависимости от .row нажатой ячейки
        doAfterSexSelected?(selectedSex)
        
        // переход к предыдущему экрану осуществляется средствами  UINavigationController котовый при помощи метода popViewController() и 
        // возвращает последний UIViewController(или UITableViewController) в массиве контроллеров хранящихся в в самОм навигейшен контороллере
        // им и является UITableViewController из предыдушего экрана ( .navigationController это свойство текущего UIViewController(или UITableViewController)
        // которыое по сути является делегатом UINavigationController в UIViewController(или UITableViewController))
        navigationController?.popViewController(animated: true)
    }
    
   
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
    
}
