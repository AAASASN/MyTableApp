//
//  AddEventHolderViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 09.09.2022.
//

import UIKit

class AddEventHolderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var firstTableView: UITableView!
    @IBOutlet weak var saveButtonOutlet: UIBarButtonItem!
        
    var firstNameTextFieldCell = FirstNameTextFieldTableViewCell()
    var lastNameTextFieldCell = LastNameTextFieldTableViewCell()
    var dateTextFieldCell = DateTextFiedTableViewCell()
    var phoneNumberTextFieldCell = PhoneNumberTextFieldTableViewCell()
    
    // свойство для загрузки в него хранилища с данными
    var eventsStorage : EventStorageProtocol = EventStorage()
    
    // создаем пустой экземрляр Юбиляра кроторый будет заполнен данными и потом добавлен в хранилище юбиляров
    var eventHolder: EventHolder!
    
//    = EventHolder(eventHolderFirstName:  "error",
//                                               eventHolderLastName: "error",
//                                               eventHolderBirthdayDate: Date(),
//                                               eventHolderPhoneNumber: "error",
//                                               sex: .none,
//                                               eventHolderStatus: .none,
//                                               // добавляем сам ДР
//                                               events: [Event]()
//                                               )
    
    // переменная для хранения текущего статуса Юбиляра
    var currentEventHolderStatus: EventHolderStatus = .none
    
    // переменная для хранения текущего пола Юбиляра
    var currentEventHolderSex: EventHolderSex = .none
    
    // создадим экземпляр UIDatePicker, далее в методе viewDidLoad
    // назначим его как способ ввода в текстовое поле addEventHolderBirthdayDateTextField
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // указаваем что класс AddEventHolderViewController будет является датасорсом и делегатом для таблицы firstTableView
        firstTableView.delegate = self
        firstTableView.dataSource = self

        // регистрируем Nib ячейку
        let cellNib = UINib(nibName: "OneEventSomeHolderTableViewCell_xib", bundle: nil)
        firstTableView.register(cellNib, forCellReuseIdentifier: "reuseIdentifier")
        
        firstNameTextFieldCell = firstTableView.dequeueReusableCell(withIdentifier: "FirstNameTextFieldTableViewCellID") as! FirstNameTextFieldTableViewCell
        lastNameTextFieldCell = firstTableView.dequeueReusableCell(withIdentifier: "LastNameTextFieldTableViewCellID") as! LastNameTextFieldTableViewCell
        dateTextFieldCell = firstTableView.dequeueReusableCell(withIdentifier: "DateTextFiedTableViewCellID") as! DateTextFiedTableViewCell
        phoneNumberTextFieldCell = firstTableView.dequeueReusableCell(withIdentifier: "PhoneNumberTextFieldTableViewCellID") as! PhoneNumberTextFieldTableViewCell
   
        
        // получим актуальный список [EventHolder] в хранилище eventsStorage
        eventsStorage.getUpdatedDataToEventStorage()
        
        // настроим кнопку "Сохранить"
        saveButtonOutlet.title = "Сохранить"
        // деактивируем ее до тех пор пока все поля не будут заполнены
        saveButtonOutlet.isEnabled = false
        
        // Настроим Навигейщен Бар
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // получим актуальный список [EventHolder] в хранилище eventsStorage
        eventsStorage.getUpdatedDataToEventStorage()
        firstTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // запускаем наблюдателя который отслеживает заполнены ли текстовые поля и если поля заполнены делает активной кнопку "Сохранить"
        fieldsObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
    }
    
    // MARK: - Кнопка сохранить
    @IBAction func saveEventHolderButton(_ sender: UIBarButtonItem) {
        // по нажатию на кнопку сохранить проверяем заполнены ли поля Пол и Статус
        // и рекомендуем заполнить вызывая UIAlertController
        if saveButtonOutlet.title == "Сохранить" {
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
                //
                savingOrEditEventHolderAndCreateBirthdayEvent()
            }
        } else {
            if saveButtonOutlet.title == "Изменить" {
                savingOrEditEventHolderAndCreateBirthdayEvent()
            }
        }
    }
    
    // функция будет принимать UIAlertController, создавать два UIAlertAction
    // и отображать их
    func presentAlert(alertController: UIAlertController) {
        let alertActionCancel = UIAlertAction(title: "Дополнить", style: .default, handler: {_ in
            // скрываем клавиатуру
            self.firstTableView.endEditing(true)
        })
        let alertActionSave = UIAlertAction(title: "Все равно сохранить", style: .cancel, handler: {_ in
            self.savingOrEditEventHolderAndCreateBirthdayEvent()
            // скрываем клавиатуру
            self.firstTableView.endEditing(true)
        })
        alertController.addAction(alertActionCancel)
        alertController.addAction(alertActionSave)
        // ///
        self.present(alertController, animated: true, completion: nil)
    }
    
    // функция либо разрешает либо запрещает редактировать поля в зависимости от статуса
    // кнопки saveButtonOutlet - Сохранить или Изменить
    // а так же создает Юбиляра с событие Birthday по умолчанию и сохраняет его
    // в массив events[]
    func savingOrEditEventHolderAndCreateBirthdayEvent(){
        if saveButtonOutlet.title == "Сохранить" {
            // меняем название кнопки saveButtonOutlet с "Сохранить" на "Изменить"
            self.saveButtonOutlet.title = "Изменить"
            
            // запрещаем редактировать все textField
            firstNameTextFieldCell.textField.isEnabled.toggle()
            lastNameTextFieldCell.textField.isEnabled.toggle()
            dateTextFieldCell.textField.isEnabled.toggle()
            phoneNumberTextFieldCell.textField.isEnabled.toggle()
            
            // скрываем клавиатуру
            self.firstTableView.endEditing(true)
            
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
                                                  eventHolderBirthdayDate: dateFormatter.date(from: dateTextFieldCell.textField.text ?? "11 августа 2011") ?? Date(),
                                                  eventHolderPhoneNumber: phoneNumberTextFieldCell.textField.text ?? "error",
                                                  sex: currentEventHolderSex,
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
                
                firstTableView.reloadData()

            } else {
                // иначе мы можем внести изменения в свойства уже созданного eventHolder а затем сохранить/или пересохранить его в хранилище
                eventHolder.eventHolderFirstName = firstNameTextFieldCell.textField.text ?? "error"
                eventHolder.eventHolderLastName = lastNameTextFieldCell.textField.text ?? "error"
                eventHolder.eventHolderBirthdayDate = dateFormatter.date(from: dateTextFieldCell.textField.text ?? "11 августа 2011") ?? Date()
                eventHolder.eventHolderPhoneNumber = phoneNumberTextFieldCell.textField.text ?? "error"
                eventHolder.sex = currentEventHolderSex
                eventHolder.eventHolderStatus = currentEventHolderStatus
                
                // внесем изменения в хранилище eventsStorage с учетом внесенных изменений в свойство eventHolder текущего контроллера
                eventsStorage.addChangesOfEventHolderToEventStorage(changedEventHolder: eventHolder)
                
                print(eventHolder.events.count)
                firstTableView.reloadData()
            }
        } else {
            if saveButtonOutlet.title == "Изменить" {
                // меняем название кнопки saveButtonOutlet с "Изменить" на "Сохранить"
                self.saveButtonOutlet.title = "Сохранить"
                // разрешаем редактировать всех textField
                
                firstNameTextFieldCell.textField.isEnabled.toggle()
                lastNameTextFieldCell.textField.isEnabled.toggle()
                dateTextFieldCell.textField.isEnabled.toggle()
                phoneNumberTextFieldCell.textField.isEnabled.toggle()
                // скрываем клавиатуру
                self.firstTableView.endEditing(true)
//                // делаем кнопку sexCellButton доступной таким образом разрешаем переход по сигвею по нажатию
//                sexCellButton.isHidden.toggle()
//                statusCellButton.isHidden.toggle()
            }
        }
        print(eventHolder.events.count)
    }
    
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension AddEventHolderViewController {

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if eventHolder != nil {
            return 3
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var forReturn = 0
        if section == 0 { forReturn = 6 }
        if section == 1 {
            if eventHolder != nil {
                forReturn = eventHolder.events.count
            }
        }
        if section == 2 {
            if eventHolder != nil { forReturn = 1 }
        }
        
        return forReturn
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var varForReturn = UITableViewCell()
        
        let sexAndStatusCell = firstTableView.dequeueReusableCell(withIdentifier: "SexAndStatusTableViewCelliD") as! SexAndStatusTableViewCell
        
        //
        let eventCell = firstTableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") as! OneEventSomeHolderTableViewCell_xib
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                firstNameTextFieldCell.textField.placeholder = "Имя"
                //firstNameTextFieldCell.textField.keyboardType = UIKeyboardType.default
                return firstNameTextFieldCell
            case 1:
                lastNameTextFieldCell.textField.placeholder = "Фамилия"
                //lastNameTextFieldCell.textField.keyboardType = UIKeyboardType.default
                return lastNameTextFieldCell
            case 2:
                dateTextFieldCell.textField.placeholder = "Дата рождения"
                dateTextFieldCell.datePickerSwttings()
                return dateTextFieldCell
            case 3:
                phoneNumberTextFieldCell.textField.placeholder = "Номер телефона"
                phoneNumberTextFieldCell.textField.keyboardType = UIKeyboardType.phonePad
                return phoneNumberTextFieldCell
            case 4:
                sexAndStatusCell.sexOrStatusLabel.text = "Пол"
                sexAndStatusCell.selectResultLabel.text = currentEventHolderSex.rawValue
                return sexAndStatusCell
            case 5:
                sexAndStatusCell.sexOrStatusLabel.text = "Статус"
                sexAndStatusCell.selectResultLabel.text = currentEventHolderStatus.rawValue
                return sexAndStatusCell
            default:
                break
            }
        }
        
        if indexPath.section == 1 {
            for i in 0..<eventHolder.events.count{
                if indexPath.row == i {
                    eventCell.eventTypeLabel.text = eventHolder.events[i].eventType.rawValue
                    eventCell.dayCountLabel.text = String(eventHolder.events[i].eventDate.daysCountBeforeEvent)
                    eventCell.eventDateLabel.text = eventHolder.events[i].eventDate.dateAsString
                    eventCell.isActualLabel.text = String(eventHolder.events[i].isActual)
                    varForReturn = eventCell
                    print("eventCell was return")
                }
            }
        }
        
        if indexPath.section == 2 {
            if eventHolder != nil {
                if indexPath.row == 0 {
                    let cellAsButton = firstTableView.dequeueReusableCell(withIdentifier: "AddEventButtonAsTableViewCellID", for: indexPath) as! AddEventButtonAsTableViewCell
                    varForReturn = cellAsButton
                }
            }
        }
        return varForReturn
    }
    

    // настройка высоты ячеек в данамической таблице
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == 0 {return 43.5}
        if indexPath.section == 1 {return 200}
        if indexPath.section == 2 {return 60}
        if indexPath.section == 0 && indexPath.row == 3 {return 50}
        if indexPath.section == 0 && indexPath.row == 4 {return 50}
        if indexPath.section == 0 && indexPath.row == 5 {return 50}

    return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if saveButtonOutlet.title == "Сохранить" {
            
            if indexPath.section == 0 && indexPath.row == 4 {
                
                // получаем вью контроллер, в который происходит переход
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let changeEventHolderSexTableViewController = storyboard.instantiateViewController(withIdentifier: "ChangeEventHolderSexTableViewControlleriD") as! ChangeEventHolderSexTableViewController
                
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
                    let cell = firstTableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! SexAndStatusTableViewCell
                    cell.selectResultLabel.text = currentEventHolderSex.rawValue
                    //firstTableView.reloadData()
                }
                // таким образом мы выполнили операции в AddEventHolderViewController при помощи замыкания doAfterSexSelected вызвав его
                // вообще в другом контроллере
                // переходим к следующему экрану
                self.navigationController?.pushViewController(changeEventHolderSexTableViewController, animated: true)
            }
            if indexPath.section == 0 && indexPath.row == 5 {
                
                // получаем вью контроллер, в который происходит переход
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let changeEventHolderStatusTableViewController = storyboard.instantiateViewController(withIdentifier: "ChangeEventHolderStatusTableViewControllerId") as! ChangeEventHolderStatusTableViewController
                
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
                    let cell = firstTableView.cellForRow(at: IndexPath(row: 5, section: 0)) as! SexAndStatusTableViewCell
                    cell.selectResultLabel.text = currentEventHolderStatus.rawValue
                    //firstTableView.reloadData()
                }
                // таким образом мы выполнили операции в AddEventHolderViewController при помощи замыкания doAfterStatusSelected вызвав его
                // вообще в другом контроллере
                // переходим к следующему экрану
                self.navigationController?.pushViewController(changeEventHolderStatusTableViewController, animated: true)
            }
        }
        
        // нажатие на кнопку "Добавить событие"
        if indexPath.section == 2 && indexPath.row == 0 {
            
            // получаем вью контроллер, в который происходит переход
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let addEventTableViewController = storyboard.instantiateViewController(withIdentifier: "AddEventTableViewControllerID") as! AddEventTableViewController
            
            // передадим свойству currentEventsHolder контроллера на который сейчас будем переходить экземрляр из свойства  eventsHolder текущего контороллера
            addEventTableViewController.currentEventsHolder = eventHolder
            // переходим к следующему экрану
            self.navigationController?.pushViewController(addEventTableViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var valueForReturn = ""
        if section == 0 {valueForReturn = "введите данные о новом юбиляре"}
        if section == 1 {
            if eventHolder != nil { valueForReturn = "перечень событий"}
            if eventHolder == nil { valueForReturn = "здесь будут показаны события" }
        }
        return valueForReturn
    }
    
    // MARK: - настройка Navigation Bar
    func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .compact)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - TextFields Observer
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
                //textField.addTarget(self, action: #selector(editingBegan(_:)), for: .editingDidBegin)
                //textField!.addTarget(self, action: #selector(editingEnded(_:)), for: .editingDidEnd)
            }
        }
    }
    
    // функция проверяет что все поля заполнены и активирует кнопку "Сохранить", если же кнопка была активна
    // и какое либо поле очистили кнопка деактивируется
    @objc func editingChanged(_ textField: UITextField) {
        if saveButtonOutlet.isEnabled == false {
            if !firstNameTextFieldCell.textField.text!.isEmpty && !lastNameTextFieldCell.textField.text!.isEmpty && !dateTextFieldCell.textField.text!.isEmpty && !phoneNumberTextFieldCell.textField.text!.isEmpty {
                saveButtonOutlet.isEnabled.toggle()
            }
        }
        if saveButtonOutlet.isEnabled == true {
            if firstNameTextFieldCell.textField.text!.isEmpty || lastNameTextFieldCell.textField.text!.isEmpty || dateTextFieldCell.textField.text!.isEmpty || phoneNumberTextFieldCell.textField.text!.isEmpty {
                saveButtonOutlet.isEnabled.toggle()
                
            }
        }
        
        //    //////////////////////////////////////////////////////////////////////
        //
        //      ЕЩЕ ВАРИАНТЫ
        //
        //    @objc func editingBegan(_ textField: UITextField) {
        //        //пользователь попал в поле, но еще ничего не ввел
        //    }
        //
        //    @objc func editingChanged(_ textField: UITextField) {
        //        //текст изменился
        //    }
        //
        //    @objc func editingEnded(_ textField: UITextField) {
        //        //ввод окончен, к примеру нажали "return" на клавиатуре
        //    }
        //    /////////////////////////////////////////////////////////////////////
        
    }

}
