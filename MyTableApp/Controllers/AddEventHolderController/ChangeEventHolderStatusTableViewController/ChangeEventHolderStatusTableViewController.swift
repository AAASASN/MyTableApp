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
    
    // это будет датаСурс таблицы
    let dataSourseForTable = [(EventHolderStatus.wife, "Какой-то комментарий о жене"),
                              (.mother, "Какой-то комментарий о маме" ),
                              (.father, "Какой-то комментарий о папе"),
                              (.brother, "Какой-то комментарий о брате"),
                              (.sister, "Какой-то комментарий о сестре"),
                              (.son, "Какой-то комментарий о сыне"),
                              (.daughter, "Какой-то комментарий о дочери"),
                              (.bestFriend, "Этот статус подойдет для близких друзей"),
                              (.colleague, "Отлично подойдет для коллег и деловых партнеров"),
                              (.schoolFriend, "Школьный друг или одногрупник по колледжу"),
                              (.someFriend, "Можно выбрать для приятелей и соседей"),
                              (.none, "Выбирайте этот статус если не можете определиться со статусом этого контакта")]
        
    // в этой переменной будет храниться текущий статус
    var selectedStatus : EventHolderStatus = .none
    
    // обработчик выбора Статуса
    // замыкание для передачи информации о выбраном поле на предыдущий экран в иерархии Навигейшен контроллера
    var doAfterStatusSelected: ((EventHolderStatus) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Статус"
        
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), style: .insetGrouped)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourseForTable.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var cellConfig = cell.defaultContentConfiguration()
        cellConfig.text = dataSourseForTable[indexPath.row].0.rawValue
        cellConfig.secondaryText = dataSourseForTable[indexPath.row].1
        cellConfig.secondaryTextProperties.font = .systemFont(ofSize: 14)
        cellConfig.secondaryTextProperties.color = .systemGray2
        cell.selectionStyle = .none
        cell.contentConfiguration = cellConfig
        if selectedStatus == dataSourseForTable[indexPath.row].0 { cell.accessoryType = .checkmark }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    // действия при нажатии на ячейку
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        let numberOfRows = tableView.numberOfRows(inSection: section)
        
        // пройдемся циклом по всем  ячейкам секции для того что бы убрать галку .checkmark
        // там где не нужно
        for row in 0..<numberOfRows {
            if let cell = tableView.cellForRow(at: NSIndexPath(row: row, section: section) as IndexPath) {
                cell.accessoryType = .none
            }
        }
        
        // ставим галку в нажатой ячейке
        if let cell = tableView.cellForRow(at: indexPath){
            selectedStatus = dataSourseForTable[indexPath.row].0
            cell.accessoryType = .checkmark
        }
        
        // вызов обработчика - передаем в замыкание doAfterSexSelected значение типа
        // selectedSex в зависимости от .row нажатой ячейки
        doAfterStatusSelected?(selectedStatus)
        
        // переход к предыдущему экрану осуществляется средствами  UINavigationController котовый при помощи метода popViewController() и
        // возвращает последний UIViewController(или UITableViewController) в массиве контроллеров хранящихся в в самОм навигейшен контороллере
        // им и является UITableViewController из предыдушего экрана ( .navigationController это свойство текущего UIViewController(или UITableViewController)
        // которыое по сути является делегатом UINavigationController в UIViewController(или UITableViewController))
        navigationController?.popViewController(animated: true)
    }
    
    
}
