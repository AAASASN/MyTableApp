//
//  StartTableViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 08.07.2022.
//

import UIKit
import Contacts

class StartTableViewController: UITableViewController {
    
    // свойство для загрузки в него хранилища с данными
    var eventsStorage : EventStorageProtocol = EventStorage()
    
    // в этом свойстве будем хранить массив кортрежей [(EventHolderProtocol, EventProtocol)]
    var eventHolderAndEventArray : [(EventHolder, EventProtocol)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // настройка Навигейшен бар
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        eventsStorage.getUpdatedDataToEventStorage()
        eventHolderAndEventArray = eventsStorage.getEventHolderAndEventArray()
        tableView.reloadData()
        
        // Здесь мы поработаем с контактами из памяти телефона
        CNContactStore().requestAccess(for: .contacts) { (success, error ) in
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        eventsStorage.getUpdatedDataToEventStorage()
        eventHolderAndEventArray = eventsStorage.getEventHolderAndEventArray()
        tableView.reloadData()
        
        // просто проверка создания eventHolderID
        if eventHolderAndEventArray.isEmpty {
            print("eventHolderAndEventArray is empty")
        } else {
            for i in 0..<eventHolderAndEventArray.count {
                print(eventHolderAndEventArray[i].0.eventHolderID)
            }
        }
        print(eventHolderAndEventArray)
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
            var valueForReturn = ""
            if section == 0 {valueForReturn = "заголовок"}

            return valueForReturn
        }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // получаем вью контроллер, в который происходит переход
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailedEventViewController = storyboard.instantiateViewController(withIdentifier: "DetailedEventViewControllerID") as! DetailedEventViewController
        
        // передадим свойству eventHolderAndEvent контроллера на который сейчас будем переходить экземрляр из свойства  eventHolderAndEventArray текущего контороллера
        //detailedEventViewController.eventHolderAndEvent = eventHolderAndEventArray[indexPath.row]
        
        // передадим свойству eventHolderAndEventID контроллера на который сейчас будем переходить кортед ID-шников eventHolderID и eventID из свойства  eventHolderAndEventArray текущего контороллера соответствующего indexPath.row
        detailedEventViewController.eventHolderAndEventID = (eventHolderAndEventArray[indexPath.row].0.eventHolderID, eventHolderAndEventArray[indexPath.row].1.eventID)

        // переходим к следующему экрану
        self.navigationController?.pushViewController(detailedEventViewController, animated: true)
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
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            self.eventHolderAndEventArray.remove(at: indexPath.row)
//
//            // удаляем из хранилища eventsStorage экземпляр EventHolder соответствующий удаляемой ячейке
//            eventsStorage.removeEventHolderFromEventSrorage(removedEventHolder: eventHolderAndEventArray[indexPath.row].0)
//
//            tableView.deleteRows(at: [indexPath], with: .none)
//            tableView.reloadData()
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//
//    }
    
    // метод для редактирования ячеек в таблице, в данном случае будет реализована возможность удалять
    // ячейку свайпом влево
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        // действие удаления
        let actionDelete = UIContextualAction(style: .destructive, title: "Удалить") { _,_,_ in
            // удаляем конкретное Event-событие из списка событий конкретного EventHolder и затем из хранилища при помощи функции
            self.eventsStorage.removeEventOfSomeEventHolderFromSomeEventHolderAndEventSrorage(
                eventHolder: self.eventHolderAndEventArray[indexPath.row].0,
                event: self.eventHolderAndEventArray[indexPath.row].1
            )
            //
            
            // обновояем eventHolderAndEventArray (он является массивом из которого наполняется таблица)
            self.eventHolderAndEventArray = self.eventsStorage.getEventHolderAndEventArray()
            // заново формируем табличное представление
            tableView.reloadData()
        }

        // формируем экземпляр, описывающий доступные действия
        let actions = UISwipeActionsConfiguration(actions: [actionDelete] )
        return actions

    }
    
}
