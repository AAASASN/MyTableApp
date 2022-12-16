//
//  ContactsSynchronizeViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 20.11.2022.
//

import UIKit

class ContactsSynchronizeViewController: UIViewController {
       
    // данные об EventHolder-ах переданные с предыдущего контроллера
    var eventHolderArray = [EventHolder]()
    
    // датасурс на остнове которого будет отображаться табличка и проставляться галочки
    var dataSourceForTable = [(EventHolder, Bool)]()
    
    // табличка
    // расположим tableView
    var tableView: UITableView!


    
    // переменная в которую при инициализации контроллера ContactsSynchronizeViewController из контроллера
    // StartTableViewController будет передано замыкание которое при вызове будет запрашивать данные из
    // хрпанилища и обновлять табличку в StartTableViewController
    var updateClosuer: ()->Void = {}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // настройка внешнего вида контроллера
        controllerSettings()
        
        // преобразуем принятый при инициализации массив в массив котрежей для использования в качестве датасурс
        dataSourceForTable = getDataSourceForTableLikeTuple(eventHoldersArray: eventHolderArray)
        
        // регистрируем ячейку для переиспользовании в таблице
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCellId")

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // не работает???
    deinit {
        print("ContactsSynchronizeViewController was deinit ")
    }
    

}
 
// MARK: -  Дата сурс
extension ContactsSynchronizeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSourceForTable.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // используем стандартную ячейку
        let standartCell = tableView.dequeueReusableCell(withIdentifier: "DefaultCellId", for: indexPath)
        
        // настройка через стандарнтый конфигуратор UIListContentConfiguration
        var content = standartCell.defaultContentConfiguration()
        content.image = UIImage(systemName: "person.circle")
        content.text = dataSourceForTable[indexPath.row].0.eventHolderFirstName + " " + dataSourceForTable[indexPath.row].0.eventHolderLastName
        content.secondaryText = " "
        content.imageProperties.tintColor = .systemPurple
        
        // при первичном формировании таблички проставим дату дня рождения - дата "1 января 0001" означает отсутствие даты
        if dataSourceForTable[indexPath.row].0.eventHolderBirthdayDate.dateAsString != "1 января 0001"  {
            content.secondaryText = dataSourceForTable[indexPath.row].0.eventHolderBirthdayDate.dateAsString
        }
        
        // при первичном формировании таблички проставим галочки только тем ячейкам в которых есть нормальная дата (true)
        if dataSourceForTable[indexPath.row].1 {
            standartCell.accessoryType = .checkmark
        } else {
            // что бы исключить проставление галки там где не нужно при переиспользовании ячеек
            standartCell.accessoryType = .none
        }
        
        standartCell.contentConfiguration = content 
        return standartCell
    }
    
    // MARK: - didSelectRowAt
    // нажатие на ячейку проставляет или отжимает галочку и сохраняет ее в датасурс
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let standartCell = tableView.cellForRow(at: indexPath)
        if standartCell?.accessoryType == Optional.none {
            standartCell?.accessoryType = .checkmark
            dataSourceForTable[indexPath.row].1.toggle()
            tableView.reloadData()
        } else {
            standartCell?.accessoryType = .none
            dataSourceForTable[indexPath.row].1.toggle()
            tableView.reloadData()
        }
    }
}


// настройка внешнего вида контроллера - таблица, панель над ней и кнопки
extension ContactsSynchronizeViewController {
    
    
    // MARK: - controllerSettings()
    // метод для настройки отображения контроллера
    func controllerSettings() {
        
        // создадим бар в верхней части контроллера
        let topCustomBar = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.maxX, height: 50))
        topCustomBar.backgroundColor = UIColor.systemGray5
        
        // создадим, настроим и добавим кнопку отмена
        let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        cancelButton.addAction(UIAction(handler: { cancelButtonPressed in
            // скроем контроллер
            self.dismiss(animated: true)
            print("Кнопка Отмена нажата")
        }), for: .touchUpInside)
        cancelButton.setTitle("Отмена", for: UIControl.State.normal)
        cancelButton.setTitleColor(UIColor.systemBlue, for: UIControl.State.normal)
        cancelButton.setTitleColor(UIColor.systemGray, for: UIControl.State.highlighted)
        topCustomBar.addSubview(cancelButton)
        
        
        // создадим, настроим и добавим кнопку сохранить
        let saveButton = UIButton(frame: CGRect(x: view.bounds.maxX - 120, y: 0, width: 100, height: 50),
                                   primaryAction: UIAction(handler: { saveButtonPressed in
            print("Кнопка Сохранить нажата ")
            self.saveButtonAction()
        }) )
        saveButton.setTitle("Сохранить", for: UIControl.State.normal)
        saveButton.setTitleColor(UIColor.systemBlue, for: UIControl.State.normal)
        saveButton.setTitleColor(UIColor.systemGray, for: UIControl.State.highlighted)
        topCustomBar.addSubview(saveButton)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 50, width: self.view.bounds.maxX, height: self.view.bounds.maxY), style: .insetGrouped)
        
        view.addSubview(topCustomBar)
        view.addSubview(tableView)
    }
}

extension ContactsSynchronizeViewController {
    
    // MARK: - saveButtonAction()
    // здесь сохраним выделенные контакты
    func saveButtonAction()  {
        // создадим экземпляр хранилища
        let eventsStorage = EventStorage()
        // обновим состояние хранилища из UserDefaults
        eventsStorage.getUpdatedDataToEventStorage()
        // засунем в хранилище eventsStorage всех eventHolder у которых была проставоена галка
        for eventHolder in getEventHolderArrayForStorageFromArrayOfTuples(eventHoldersArray: dataSourceForTable) {
            eventsStorage.addEventHolderToEventSrorage(newEventHolder: eventHolder)
        }
        // обновим контороллер StartTableViewController
        updateClosuer()

        // скроем контроллер
        self.dismiss(animated: true)
    }
}

extension ContactsSynchronizeViewController {
    
    // MARK: - getDataSourceForTableLikeTuple
    // вазвращаем массив кортежей который который будем использовать в качестве датасурс, он поможет проставлять галочки в ячейках
    func getDataSourceForTableLikeTuple(eventHoldersArray: [EventHolder]) -> [(EventHolder, Bool)] {
        var valueForReturn = [(EventHolder, Bool)]()
        for eventHolder in eventHoldersArray {
            if eventHolder.eventHolderBirthdayDate.dateAsString == "1 января 0001" {
                valueForReturn.append((eventHolder, false))
            } else {
                valueForReturn.append((eventHolder, true))
            }
        }
        return valueForReturn
    }
    
    // MARK: - getEventHolderArrayForStorageFromArrayOfTuples
    // этот метод напротив переводит массив кортежей в массив EventHolder помещая в него только те у которых была проставлена галочка
    func getEventHolderArrayForStorageFromArrayOfTuples(eventHoldersArray: [(EventHolder, Bool)] ) -> [EventHolder] {
        var valueForReturn = [EventHolder]()

        for tuple in eventHoldersArray {
            if tuple.1 { valueForReturn.append(tuple.0) }
        }
        return valueForReturn
    }
    
}


