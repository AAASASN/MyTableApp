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
    
    // в этом свойстве будем хранить словарь ключами в котором будет eventHolserStatus а значениями массивы из типов Event
    var eventDictionarySortedByEventHolderStatus : [EventHolderStatus : [EventHolderProtocol]] = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        eventDictionarySortedByEventHolderStatus = eventsStorage.sortEventStorageByEventHolderStatus()
    }
}

// MARK: - extension
/* в расширении переопределим четыре метода родительского класса UITableViewController
 
- numberOfSections        - обязательный метод протокола UITableViewDataSource, возвращает количество секций в таблице
- cellForRowAt            - обязательный метод протокола UITableViewDataSource, возвращает переиспользуемую ячейку
- numberOfRowsInSection   - обязательный метод протокола UITableViewDataSource, Возвращаем количество строк в секции равное количеству элементов массива
- titleForHeaderInSection - НЕ обязательный метод протокола UITableViewDataSource, возврвщает заголовок в секцию
*/

extension StartTableViewController {
    
    // возвращаем количество секций
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections = 0
        numberOfSections = eventsStorage.sortEventStorageByEventHolderStatus().count
        print("numberOfSections \(numberOfSections)")
        return numberOfSections
    }
    
    // возвращаем ячейку
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "startControllerCellReuseIdentifier", for: indexPath) as! StartControllerCustomCell
        
        // заполним массив статусов которые содержатся в eventDictionarySortedByEventHolderStatus
        var eventsHolderStsatusArray = [EventHolderStatus]()
        for i in eventDictionarySortedByEventHolderStatus {
            eventsHolderStsatusArray.append(i.key)
        }
        
        let section = eventsHolderStsatusArray[indexPath.section]

        guard let eventsArrayFromEventsStatusHolder = eventDictionarySortedByEventHolderStatus[section] else {
            cell.nameLabel.text = "error"
            return cell
        }
        
        
        //var nameForLabel = Event(eventHolder: "", eventDate: "", eventDiscription: <#String#>, eventHolderStatus: .none, isActual: <#Bool#>, eventType: .none)
        
        var nameForLabel = EventHolder(eventHolderFirstName: "", eventHolderLastName: "", eventHolderStatus: .none, events: [], eventHolderPhoneNumber: "", sex: true)
        if let nameForLabelInIf = eventsArrayFromEventsStatusHolder[indexPath.row] as? EventHolder {
            nameForLabel = nameForLabelInIf
        }
        
        cell.nameLabel.text = nameForLabel.eventHolderFirstName + " " + nameForLabel.eventHolderLastName
        cell.dateLabel.text = nameForLabel.events[0].eventDate
        cell.eventTypeLabel.text = nameForLabel.events[0].eventType.rawValue
        cell.friendStatusLabel.text = nameForLabel.eventHolderStatus.rawValue
        return cell
    }
    
    // Возвращаем количество строк в секции равное количеству элементов массива
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dictEventHoderStatusToEvents = eventDictionarySortedByEventHolderStatus
        var eventsHolderStsatusArray = [EventHolderStatus]()
        for i in dictEventHoderStatusToEvents {
            eventsHolderStsatusArray.append(i.key)
        }
        
        guard let returnArrayCount = dictEventHoderStatusToEvents[eventsHolderStsatusArray[section]] else { return 5 }
        
        return returnArrayCount.count
        

    }
    
    // Вывод заголовка в секцию
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        let dictEventHoderStatusToEvents = eventDictionarySortedByEventHolderStatus
        
        // печатаем dicForReturn
        for i in dictEventHoderStatusToEvents {
            print("ключ - \(i.key)")
            for r in i.value {
                print("\(String(describing: r.eventHolderLastName))")
            }
        }
        
        var eventsHolderStsatusArray = [EventHolderStatus]()
        for i in dictEventHoderStatusToEvents {
            eventsHolderStsatusArray.append(i.key)
        }
        return eventsHolderStsatusArray[section].rawValue
    }
                      
    
}
