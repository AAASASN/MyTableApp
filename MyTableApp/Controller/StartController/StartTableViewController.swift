//
//  StartTableViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 08.07.2022.
//

import UIKit

class StartTableViewController: UITableViewController {
    
    // свойство для загрузки в него хранилища с данными
    var eventsStorage : EventStorageProtocol = EventStorage()
    
    // в этом свойстве будем хранить массив кортрежей [(EventHolderProtocol, EventProtocol)]
    var eventHolderAndEventArray : [(EventHolder, EventProtocol)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        eventHolderAndEventArray = eventsStorage.getEventHolderAndEventArray()
    }
}

// MARK: - extension
/* в расширении переопределим четыре метода родительского класса UITableViewController
 
- numberOfSections        - обязательный метод протокола UITableViewDataSource, возвращает количество секций в таблице
- cellForRowAt            - обязательный метод протокола UITableViewDataSource, возвращает переиспользуемую ячейку
- numberOfRowsInSection   - обязательный метод протокола UITableViewDataSource, Возвращаем количество строк в секции равное количеству элементов массива
- titleForHeaderInSection - НЕ обязательный метод протокола UITableViewDataSource, возврвщает заголовок в секцию
*/

// qqqqqqqqqqq


extension StartTableViewController {
    
    // возвращаем количество секций
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // возвращаем ячейку
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM yyyy"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "startControllerCellReuseIdentifier", for: indexPath) as! StartControllerCustomCell

        let tuple = eventHolderAndEventArray[indexPath.row]
        cell.nameLabel.text = tuple.0.eventHolderFirstName + " " + tuple.0.eventHolderLastName

        cell.dateLabel.text =  String(tuple.1.eventDate.daysCountBeforeEvent)
        
        cell.eventTypeLabel.text = tuple.1.eventType.rawValue + " " + dateFormatter.string(from: tuple.1.eventDate.date)
        return cell
    }
    
    // Возвращаем количество строк в секции равное количеству элементов массива
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventHolderAndEventArray.count
    }
    
//    // Вывод заголовка в секцию
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        let dictEventHoderStatusToEvents = eventDictionarySortedByEventHolderStatus
//
//        // печатаем dicForReturn
//        for i in dictEventHoderStatusToEvents {
//            print("ключ - \(i.key)")
//            for r in i.value {
//                print("\(String(describing: r.eventHolderLastName))")
//            }
//        }
//
//        var eventsHolderStsatusArray = [EventHolderStatus]()
//        for i in dictEventHoderStatusToEvents {
//            eventsHolderStsatusArray.append(i.key)
//        }
//        return eventsHolderStsatusArray[section].rawValue
//    }
    
    
    //    // Override to support conditional editing of the table view.
    //    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        // Return false if you do not want the specified item to be editable.
    //        return true
    //    }
    
    
    // метод для редактирования ячеек в таблице, в данном случае будет реализована возможность удалять
    // ячейку свайпом влево
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.eventHolderAndEventArray.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .none)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }

    }
    
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        // действие удаления
//        let actionDelete = UIContextualAction(style: .destructive, title: "Удалить") { _,_,_ in
//            self.eventHolderAndEventArray.remove(at: indexPath.row)
//            // заново формируем табличное представление
//            tableView.reloadData()
//        }
//
//        // формируем экземпляр, описывающий доступные действия
//        let actions = UISwipeActionsConfiguration(actions: [actionDelete] )
//        return actions
//
//    }
    
}
