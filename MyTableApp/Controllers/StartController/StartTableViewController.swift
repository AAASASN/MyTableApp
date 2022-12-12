//
//  StartTableViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 08.07.2022.
//

import UIKit
import Contacts

class StartTableViewController: UITableViewController {
    
    // это аутлет кнопки синхронизации контактов из телефонной книги
    @IBOutlet weak var synchronizeItemOutlet: UIBarButtonItem!
    
    // свойство для загрузки в него хранилища с данными
    var eventsStorage : EventStorageProtocol = EventStorage()
    
    // в этом свойстве будем хранить массив кортрежей [(EventHolderProtocol, EventProtocol)]
    var eventHolderAndEventArray : [(EventHolder, EventProtocol)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // при загрузке viewDidLoad() как обычно выгружаем данные из UserDefaults
        eventsStorage.getUpdatedDataToEventStorage()
    
        // выгружаем данные об EventHolder-ах и их Event-ах из хранилища в локальный массив кортежей eventHolderAndEventArray
        // который в текущем контроллере является датасурсом для таблицы.
        eventHolderAndEventArray = eventsStorage.getEventHolderAndEventArray()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // обновляем хранилище
        eventsStorage.getUpdatedDataToEventStorage()
        eventHolderAndEventArray = eventsStorage.getEventHolderAndEventArray()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // после отображения экрана делаем проверку хранилища, если оно пустое значит
        // это первый запуск приложения и нужно сделать запрос в телефонную книгу и запросить контакты
        // в этот момент происходит запрос на доступ приложения к контактам телефона
        if eventsStorage.eventHolderArrayAsClass.eventHolderArray.isEmpty {
            // запрос на выгрузку и выгрузка контактов из телефонной книги
            eventsStorage.getEventHolderArrayFromPhoneContacts()
        }
        tableView.reloadData()
    }
    
    // MARK: - synchronizeItemPressed
    // нажатие кнопки Синхронизации контактов
    @IBAction func synchronizeItemPressed(_ sender: UIBarButtonItem) {
        
        // запрос на выгрузку и выгрузка контактов из телефонной книги
        self.eventsStorage.getEventHolderArrayFromPhoneContacts()
        
        // делаем проверку - если в eventsStorage.eventHolderArrayGotFromContacts ничего
        // не выгрузилось значит нет прав доступа к контактам (!!! возможен еще вариант что тел книга телефона пуста!!!!)
        if self.eventsStorage.eventHolderArrayGotFromContacts.isEmpty {
            // вызываеи Алерт с просьбой предоставить доступ через настройка телефона
            self.showAlertMessage()
        } else {
            // если из телефонной книги всеже что то выгрузилось создаем новый конторллер
            // передаем в него то что выгрузилось и вызываем его
            self.eventsStorage.getEventHolderArrayFromPhoneContacts()
            let contactsSynchronizeViewController = ContactsSynchronizeViewController()
            contactsSynchronizeViewController.eventHolderArray = eventsStorage.eventHolderArrayGotFromContacts
            
            // замыкание которое будет передаваться на ContactsSynchronizeViewController вызываться и обновнлять данные на StartTableViewController
            let updateClosuer: () -> Void = { [ self] in
                eventsStorage.getUpdatedDataToEventStorage()
                eventHolderAndEventArray = self.eventsStorage.getEventHolderAndEventArray()
                tableView.reloadData()
            }
            contactsSynchronizeViewController.updateClosuer = updateClosuer
            
            //self.navigationController?.pushViewController(contactsSynchronizeViewController, animated: true)
            self.present(contactsSynchronizeViewController, animated: true )
        }
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
    
    // MARK: - numberOfSections
    // возвращаем количество секций
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - cellForRowAt
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
    
    // MARK: - numberOfRowsInSection
    // Возвращаем количество строк в секции равное количеству элементов массива
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventHolderAndEventArray.count
    }
    
    // заголовок в секциях
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
            var valueForReturn = ""
            if section == 0 {valueForReturn = "заголовок"}

            return valueForReturn
        }
    
    // MARK: - didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // получаем вью контроллер, в который происходит переход
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailedEventViewController = storyboard.instantiateViewController(withIdentifier: "DetailedEventViewControllerID") as! DetailedEventViewController
        
        // передадим свойству eventHolderAndEvent контроллера на который сейчас будем переходить экземрляр из свойства  eventHolderAndEventArray текущего контороллера
        //detailedEventViewController.eventHolderAndEvent = eventHolderAndEventArray[indexPath.row]
        
        // передадим свойству eventHolderAndEventID контроллера на который сейчас будем переходить кортеж ID-шников eventHolderID и eventID из свойства  eventHolderAndEventArray текущего контороллера соответствующего indexPath.row
        detailedEventViewController.eventHolderAndEventID = (eventHolderAndEventArray[indexPath.row].0.eventHolderID, eventHolderAndEventArray[indexPath.row].1.eventID)

        // переходим к следующему экрану
        self.navigationController?.pushViewController(detailedEventViewController, animated: true)
    }
    
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


// MARK: - Алерт
// с уведомлением об отсутствии доступа
extension StartTableViewController {
    func showAlertMessage() {
        let alertMessage = UIAlertController(title: "Упс, разрешите приложению доступ к контактам", message: "Настройки -> Конфиденциальность -> Контакты -> BirthdayApp ", preferredStyle: .alert)
        let alertActionsOk = UIAlertAction(title: "OK", style: .default)
        alertMessage.addAction(alertActionsOk)
        self.present(alertMessage, animated: true)
    }
}
