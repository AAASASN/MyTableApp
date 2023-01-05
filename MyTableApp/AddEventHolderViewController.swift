//
//  AddEventHolderViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 09.09.2022.
//

import UIKit

class AddEventHolderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var saveButtonItem: UIBarButtonItem!
    
    var firstNameTextFieldCell: TextFieldTableViewCell!
    var lastNameTextFieldCell: TextFieldTableViewCell!
    var dateTextFieldCell: TextFieldTableViewCell!
    var phoneNumberTextFieldCell: TextFieldTableViewCell!
    var sexCell:  SexAndStatusTableViewCell!
    var statusCell: SexAndStatusTableViewCell!
    
    // свойство для загрузки в него хранилища с данными
    var eventsStorage : EventStorageProtocol = EventStorage()
    
    // создаем пустой экземрляр Юбиляра кроторый будет заполнен данными и потом добавлен в хранилище юбиляров
    var eventHolder: EventHolder!
    
    // переменная для хранения текущего статуса Юбиляра
    var currentEventHolderStatus: EventHolderStatus = .none
    
    // переменная для хранения текущего пола Юбиляра
    var currentEventHolderSex: EventHolderSex = .none
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSettings()
        saveButtonItemSettings()
        createCells()
        setupNavigationBar()
        cellContentSettings()
        
        // указаваем что класс AddEventHolderViewController будет является датасорсом и делегатом для таблицы tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        // регистрируем Nib ячейку
        let cellNib = UINib(nibName: "OneEventSomeHolderTableViewCell_xib", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "reuseIdentifier")
        
        
        // получим актуальный список [EventHolder] в хранилище eventsStorage
        eventsStorage.getUpdatedDataToEventStorage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // получим актуальный список [EventHolder] в хранилище eventsStorage
        eventsStorage.getUpdatedDataToEventStorage()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // запускаем наблюдателя который отслеживает заполнены ли текстовые поля и если поля заполнены делает активной кнопку "Сохранить"
        fieldsObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    
    // MARK: - подготовка экрана при вызове с DetailedEventViewController
    // в этом случае контроллер AddEventHolderViewController будет использоваться уже не для добавления EventHolder а для просмотра и изменения уже существующего EventHolder
    func prepareForReqestFromDetailedEventViewController(someEventHolderID: String) {
        // передадим значение типа EventHolder
        eventHolder = eventsStorage.getEventHolderFromStorageByEventHolderID(eventHolderID: someEventHolderID)
        // передаем на navigationItem имя eventHolder
        self.navigationItem.title = eventHolder.eventHolderFirstName + " " + eventHolder.eventHolderLastName
        
        // настройка большого navigationItem.title
        self.navigationItem.largeTitleDisplayMode = .always
        
        currentEventHolderStatus = eventHolder.eventHolderStatus
        currentEventHolderSex = eventHolder.eventHolderSex
        
    }
    

    // MARK: - presentAlert
    // функция будет принимать UIAlertController, создавать два UIAlertAction
    // и отображать их
    func presentAlert(alertController: UIAlertController) {
        let alertActionCancel = UIAlertAction(title: "Дополнить", style: .default, handler: {_ in
            // скрываем клавиатуру
            self.tableView.endEditing(true)
        })
        let alertActionSave = UIAlertAction(title: "Все равно сохранить", style: .cancel, handler: {_ in
            self.savingOrEditEventHolderAndCreateBirthdayEvent()
            // скрываем клавиатуру
            self.tableView.endEditing(true)
        })
        alertController.addAction(alertActionCancel)
        alertController.addAction(alertActionSave)
        // ///
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - savingOrEditEventHolderAndCreateBirthdayEvent
    // функция либо разрешает либо запрещает редактировать поля в зависимости от статуса
    // кнопки saveButtonOutlet - Сохранить или Изменить
    // а так же создает Юбиляра с событие Birthday по умолчанию и сохраняет его
    // в массив events[]
    func savingOrEditEventHolderAndCreateBirthdayEvent(){
        
        if saveButtonItem.title == "Сохранить" {
            
            // меняем название кнопки saveButtonOutlet с "Сохранить" на "Изменить"
            self.saveButtonItem.title = "Изменить"
            
            // запрещаем редактировать все textField
            firstNameTextFieldCell.textField.isEnabled.toggle()
            lastNameTextFieldCell.textField.isEnabled.toggle()
            dateTextFieldCell.textField.isEnabled.toggle()
            phoneNumberTextFieldCell.textField.isEnabled.toggle()
            
            // скрываем клавиатуру
            self.tableView.endEditing(true)
            
            // для корректного формата даты
            let dateFormatter = DateFormatter()
            // настроим локализацию - для отображения на русском языке
            dateFormatter.locale = Locale(identifier: "ru_RU")
            // настроим вид отображения даты в текстовом виде
            dateFormatter.dateFormat = "d MMMM yyyy"
            
            // проверяем свойство eventHolder, если  оно равно nil то и eventHolder по сути еще не создавался и не сохранялся, тогда создаем новый экземпляр tempEventHolder: EventHolder, потом мы присвоим его eventHolder
            if eventHolder  == nil  {
                // создаем новый экземпляр tempEventHolder: EventHolder, потом мы присвоим его eventHolder
                let tempEventHolder = EventHolder(eventHolderFirstName: firstNameTextFieldCell.textField.text ?? "error",
                                                  eventHolderLastName: lastNameTextFieldCell.textField.text ?? "error",
                                                  eventHolderBirthdayDate: CustomDate(date: dateFormatter.date(from: dateTextFieldCell.textField.text ?? "11 августа 2011") ?? Date()),
                                                  eventHolderPhoneNumber: phoneNumberTextFieldCell.textField.text ?? "error",
                                                  eventHolderSex: currentEventHolderSex,
                                                  eventHolderStatus: currentEventHolderStatus,
                                                  // добавляем сам ДР
                                                  events: [Event(eventDate: CustomDate(date: dateFormatter.date(from: dateTextFieldCell.textField.text ?? "11 августа 2011") ?? Date()),
                                                                 eventType: .birthday,
                                                                 eventDiscription: "просто др",
                                                                 isActual: true)]
                )
                // теперь присваиваем наше tempEventHolder в постоянное свойство класса eventHolder
                eventHolder = tempEventHolder
                
                // !!!!  передадим созданное событие в Хранилище EventStorage при помощи метода  !!!!!
                eventsStorage.addEventHolderToEventSrorage(newEventHolder: eventHolder)
                
                // получим актуальный список [EventHolder] в хранилище eventsStorage
                eventsStorage.getUpdatedDataToEventStorage()
                
                tableView.reloadData()
                
            } else {
                // иначе мы можем внести изменения в свойства уже созданного eventHolder а затем сохранить/или пересохранить его в хранилище
                eventHolder.eventHolderFirstName = firstNameTextFieldCell.textField.text ?? "error"
                eventHolder.eventHolderLastName = lastNameTextFieldCell.textField.text ?? "error"
                eventHolder.eventHolderBirthdayDate = CustomDate(date: dateFormatter.date(from: dateTextFieldCell.textField.text ?? "11 августа 2011") ?? Date())
                eventHolder.eventHolderPhoneNumber = phoneNumberTextFieldCell.textField.text ?? "error"
                eventHolder.eventHolderSex = currentEventHolderSex
                eventHolder.eventHolderStatus = currentEventHolderStatus
                
                // внесем изменения в хранилище eventsStorage с учетом внесенных изменений в свойство eventHolder текущего контроллера
                eventsStorage.addChangesOfEventHolderToEventStorage(changedEventHolder: eventHolder)
                
                print(eventHolder.events.count)
                tableView.reloadData()
            }
        } else {
            if saveButtonItem.title == "Изменить" {
                // меняем название кнопки saveButtonOutlet с "Изменить" на "Сохранить"
                self.saveButtonItem.title = "Сохранить"
                // разрешаем редактировать всех textField
                
                firstNameTextFieldCell.textField.isEnabled.toggle()
                lastNameTextFieldCell.textField.isEnabled.toggle()
                dateTextFieldCell.textField.isEnabled.toggle()
                phoneNumberTextFieldCell.textField.isEnabled.toggle()
                // скрываем клавиатуру
                self.tableView.endEditing(true)
            }
        }
        print(eventHolder.events.count)
    }
}


// MARK: - Table view data source
extension AddEventHolderViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if eventHolder != nil {
            return 2 + eventHolder.events.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var forReturn = 0
        if section == 0 {
            forReturn = 6
        } else {
            if eventHolder != nil { forReturn = 1 }
        }
        return forReturn
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // возвращаемое значение
        var varForReturn = UITableViewCell()
        
        // ячейка для для отображения нового события
        let eventCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") as! OneEventSomeHolderTableViewCell_xib
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return firstNameTextFieldCell
            case 1:
                return lastNameTextFieldCell
            case 2:
                return dateTextFieldCell
            case 3:
                return phoneNumberTextFieldCell
            case 4:
                sexCell.selectResultLabel.text = currentEventHolderSex.rawValue
                return sexCell
            case 5:
                statusCell.selectResultLabel.text = currentEventHolderStatus.rawValue
                return statusCell
            default:
                break

            }
            
        } else {
            for i in 1..<eventHolder.events.count + 1 {
                if indexPath.section == i {
                    eventCell.configLabelsAndColorStile(eventID: (eventHolder, eventHolder.events[i-1]).1.eventID)
                    varForReturn = eventCell
                    print("eventCell was return")
                }
            }
        }
        
        if indexPath.section == eventHolder.events.count + 1 {
            if eventHolder != nil {
                if indexPath.row == 0 {
                    let cellAsButton = tableView.dequeueReusableCell(withIdentifier: "AddEventButtonAsTableViewCellID", for: indexPath) as! AddEventButtonAsTableViewCell
                    varForReturn = cellAsButton
                }
            }
        }
        return varForReturn
    }
    
    
    // настройка высоты ячеек в данамической таблице
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {return 43.5}
        if indexPath.section > 0 && indexPath.section <= eventHolder.events.count  {return 200}
        if indexPath.section == 2 + eventHolder.events.count {return 60}
        if indexPath.section == 0 && indexPath.row == 3 {return 50}
        if indexPath.section == 0 && indexPath.row == 4 {return 50}
        if indexPath.section == 0 && indexPath.row == 5 {return 50}
        return 50
    }
    
    // при нажатии на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // если активна кнопка "Сохранить"
        if saveButtonItem.title == "Сохранить" {
            // при нажатии на пятую ячейку - выбор пола
            if indexPath.section == 0 && indexPath.row == 4 {
                
                let changeEventHolderSexTableViewController = ChangeEventHolderSexTableViewController()
                
                // передача текущего статуса, при первом переходе статус всегда будет - .none
                changeEventHolderSexTableViewController.selectedSex = currentEventHolderSex
                
                // передача обработчика выбора статуса
                // doAfterSexSelected является свойством-замыканием у которого есть тело-замыкание( тело функции),
                // передаем(присваеваем) ему это тело-реализацию функции, после этого в свойстве doAfterSexSelected будет
                // храниться реализация замыкания(функции), и когда в будущем к этому свойству doAfterSexSelected будут обращаться
                // функция будет выполняться
                changeEventHolderSexTableViewController.doAfterSexSelected = {[self] selectedSex in
                    // изменяем статус пользователя в контроллере AddEventHolderViewController
                    self.currentEventHolderSex = selectedSex
                    let cell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! SexAndStatusTableViewCell
                    cell.selectResultLabel.text = currentEventHolderSex.rawValue
                }
                
                // таким образом мы выполнили операции в AddEventHolderViewController при помощи замыкания doAfterSexSelected вызвав его
                // вообще в другом контроллере
                // переходим к следующему экрану
                self.navigationController?.pushViewController(changeEventHolderSexTableViewController, animated: true)
            }
            
            // если нажата ячейка 6 - выбор статуса
            if indexPath.section == 0 && indexPath.row == 5 {
                
                let changeEventHolderStatusTableViewController = ChangeEventHolderStatusTableViewController()
                
                // передача текущего статуса, при первом переходе статус всегда будет - .none
                changeEventHolderStatusTableViewController.selectedStatus = currentEventHolderStatus
                
                // передача обработчика выбора статуса
                // doAfterStatusSelected является свойством-замыканием у которого есть тело-замыкание( тело функции),
                // передаем(присваеваем) ему это тело-реализацию функции, после этого в свойстве doAfterStatusSelected будет
                // храниться реализация замыкания(функции), и когда в будущем к этому свойству doAfterStatusSelected будут обращаться
                // функция будет выполняться
                changeEventHolderStatusTableViewController.doAfterStatusSelected = {[self] selectedStatus in
                    // изменяем статус пользователя в контроллере AddEventHolderViewController
                    self.currentEventHolderStatus = selectedStatus
                    // получаем ссылку на конкретную ячейку по IndexPath
                    let cell = tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as! SexAndStatusTableViewCell
                    cell.selectResultLabel.text = currentEventHolderStatus.rawValue
                    //firstTableView.reloadData()
                }
                // таким образом мы выполнили операции в AddEventHolderViewController при помощи замыкания doAfterStatusSelected вызвав его
                // вообще в другом контроллере
                // переходим к следующему экрану
                self.navigationController?.pushViewController(changeEventHolderStatusTableViewController, animated: true)
            }
        }
        
        // если eventHolder уже создан на экране то становится активна кнопка "Добавить событие"
        if eventHolder != nil {
            // при нажатии на кнопку "Добавить событие"
            if indexPath.section == eventHolder.events.count + 1 {
                // получаем вью контроллер, в который происходит переход
                let addEventViewController = AddEventViewController()
                // передадим свойству currentEventsHolder контроллера на который сейчас будем переходить экземрляр из свойства  eventsHolder текущего контороллера
                addEventViewController.currentEventsHolder = eventHolder
                // переходим к следующему экрану
                self.navigationController?.pushViewController(addEventViewController, animated: true)
            }
        }
    }
    
    
    // MARK: - настройка Navigation Bar
    func setupNavigationBar() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .compact)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}



// MARK: - TextFields Observer
extension AddEventHolderViewController {
    
    func fieldsObserver() {
        // в этом фрагменте кода проходим по массиву текстовых полей и запускаем для каждого из них
        // наблюдателя .addTarget
        let textFields = [firstNameTextFieldCell.textField,
                          lastNameTextFieldCell.textField,
                          dateTextFieldCell.textField,
                          phoneNumberTextFieldCell.textField]
        for textField in textFields {
            if textField?.isEditing == false{
                // метод addTarget унаследованный от UIControl позволяет выполнять функцию в селекторе #selector() при выполнения условия for: .editingChanged
                textField!.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
                
            }
        }
    }
    
    // функция проверяет что все поля заполнены и активирует кнопку "Сохранить", если же кнопка была активна
    // и какое либо поле очистили кнопка деактивируется
    @objc func editingChanged(_ textField: UITextField) {
        
        if saveButtonItem.isEnabled == false {
            if !firstNameTextFieldCell.textField.text!.isEmpty && !lastNameTextFieldCell.textField.text!.isEmpty && !dateTextFieldCell.textField.text!.isEmpty && !phoneNumberTextFieldCell.textField.text!.isEmpty {
                saveButtonItem.isEnabled.toggle()
            }
        }
        
        if saveButtonItem.isEnabled == true {
            
            if firstNameTextFieldCell.textField.text!.isEmpty || lastNameTextFieldCell.textField.text!.isEmpty || dateTextFieldCell.textField.text!.isEmpty || phoneNumberTextFieldCell.textField.text!.isEmpty {
                saveButtonItem.isEnabled.toggle()
                
            }
        }
    }
    
}


// MARK: - tableViewSettings
extension AddEventHolderViewController {
    
    func tableViewSettings()  {
        tableView = {
            let tableView = UITableView(frame: .zero, style: .insetGrouped)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(tableView)
            NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: view.topAnchor),
                                         tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                         tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                         tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                                        ])
            return tableView
        }()
    }
}


// MARK: - cellContentSettings
extension AddEventHolderViewController {
    
    func cellContentSettings() {
        if eventHolder != nil {
            // заполним текстовые поля в соответствии с принятыми данными о EventHolder
            firstNameTextFieldCell.textField.text = eventHolder.eventHolderFirstName
            lastNameTextFieldCell.textField.text = eventHolder.eventHolderLastName
            dateTextFieldCell.textField.text = formatDateWithoutYear(eventDate: eventHolder.eventHolderBirthdayDate.dateAsString)
            phoneNumberTextFieldCell.textField.text = eventHolder.eventHolderPhoneNumber
            
            // настроим кнопку "Сохранить" с "Сохранить" на "Изменить"
            saveButtonItem.title = "Изменить"
            // деактивируем ее до тех пор пока все поля не будут заполнены
            saveButtonItem.isEnabled = true
            
            // запрещаем редактировать все textField
            firstNameTextFieldCell.textField.isEnabled.toggle()
            lastNameTextFieldCell.textField.isEnabled.toggle()
            dateTextFieldCell.textField.isEnabled.toggle()
            phoneNumberTextFieldCell.textField.isEnabled.toggle()
            
        } else {
            
            // настроим кнопку "Сохранить"
            saveButtonItem.title = "Сохранить"
            // деактивируем ее до тех пор пока все поля не будут заполнены
            saveButtonItem.isEnabled = false
        }
    }
}


// MARK: - createCells
extension AddEventHolderViewController {
    
    func createCells()  {
        firstNameTextFieldCell = TextFieldTableViewCell(style: .default, reuseIdentifier: nil , textFieldType: .firstNameTextField)
        lastNameTextFieldCell = TextFieldTableViewCell(style: .default, reuseIdentifier: nil , textFieldType: .lastNameTextField)
        dateTextFieldCell = TextFieldTableViewCell(style: .default, reuseIdentifier: nil , textFieldType: .dateTextField)
        phoneNumberTextFieldCell = TextFieldTableViewCell(style: .default, reuseIdentifier: nil, textFieldType: .phoneTextField)
        sexCell =  SexAndStatusTableViewCell(style: .default, reuseIdentifier: nil, cellType: .sex)
        statusCell = SexAndStatusTableViewCell(style: .default, reuseIdentifier: nil, cellType: .status)
    }
}


// MARK: - saveButtonItemSettings
extension AddEventHolderViewController {
    
    func saveButtonItemSettings()  {
        
        saveButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveButtonItemAction))
        navigationItem.rightBarButtonItem = saveButtonItem
        
    }
    
    @objc
    func saveButtonItemAction() {
        // по нажатию на кнопку сохранить проверяем заполнены ли поля Пол и Статус
        // и рекомендуем заполнить вызывая UIAlertController
        if saveButtonItem.title == "Сохранить" {
            if currentEventHolderStatus == .none && currentEventHolderSex == .none {
                let alertSexAndStatus = UIAlertController(title: "Внимание!", message: "Вы оставили поля Пол и Статус без изменений, рекомендуем их заполнить", preferredStyle: .alert)
                presentAlert(alertController: alertSexAndStatus)
            }
            if currentEventHolderStatus == .none && currentEventHolderSex != .none {
                let alertSexAndStatus = UIAlertController(title: "Внимание!", message: "Вы оставили поле Статус без изменений, рекомендуем его заполнить", preferredStyle: .alert)
                presentAlert(alertController: alertSexAndStatus)
            }
            if currentEventHolderStatus != .none && currentEventHolderSex == .none {
                let alertSexAndStatus = UIAlertController(title: "Внимание!", message: "Вы оставили поле Пол без изменений, рекомендуем его заполнить", preferredStyle: .alert)
                presentAlert(alertController: alertSexAndStatus)
            }
            if currentEventHolderStatus != .none && currentEventHolderSex != .none {
                savingOrEditEventHolderAndCreateBirthdayEvent()
            }
        } else {
            if saveButtonItem.title == "Изменить" {
                savingOrEditEventHolderAndCreateBirthdayEvent()
            }
        }
    }
}

