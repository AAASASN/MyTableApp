//
//  ChangeEventHolderSexTableViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 31.07.2022.
//


import UIKit

class ChangeEventHolderSexTableViewController: UITableViewController {
    
    // замыкание для передачи информации о выбраном поле на предыдущий экран в иерархии Навигейшен контроллера
    var doAfterSexSelected : ((EventHolderSex) -> Void)?
    
    // в этой переменной будет храниться текущий пол
    var selectedSex : EventHolderSex = .none
    
    let dataSourseForTable = [(EventHolderSex.male, "мужской пол"),
                              (EventHolderSex.female, "женский пол"),
                              (EventHolderSex.third, "на случай если кто-то еще не определился"),
                              (EventHolderSex.none, "выбор по умолчанию")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Пол"
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), style: .insetGrouped)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tableView.endEditing(true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSourseForTable.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Выберите пол юбиляра"
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "в будущем варианты возможно будут расширены..."
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
    // перед отображением проверяем значение в selectedSex - это пол переданый
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
