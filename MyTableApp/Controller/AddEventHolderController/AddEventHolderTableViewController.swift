//
//  AddEventHolderTableViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 18.07.2022.
//

import UIKit


class AddEventHolderTableViewController: UITableViewController {
    
    @IBOutlet weak var addFirstNameTextField: UITextField!
    @IBOutlet weak var addSecondNameTextField: UITextField!
    @IBOutlet weak var addEventHolderBirthdayDateTextField: UITextField!
    @IBOutlet weak var addEventHolderPhoneNumberTextField: UITextField!
    
    @IBOutlet weak var eventHolderSexLabel: UILabel!
    @IBOutlet weak var eventHolderStatusLabel: UILabel!
    
    @IBOutlet weak var saveButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var sexCellButton: UIButton!
    @IBOutlet weak var statusCellButton: UIButton!
    
    // аутлеты для ячейки в которой будет отображаться вновь добавленное событие
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var countDaysBeforeEventLabel: UILabel!
    
    
    var labelForCell6 = ""
    
    // переменная для хранения текущего статуса Юбиляра
    var currentEventHolderStatus: EventHolderStatus = .none
    
    // переменная для хранения текущего пола Юбиляра
    var currentEventHolderSex: EventHolderSex = .none
    
    // при добавлении Юбиляра будет создаваться событие которое будет храниться в массиве
    var events: [EventProtocol] = []
    
    // создаем пустой экземрляр Юбиляра кроторый будет заполнен данными и потом добавлен в хранилище юбиляров
    var eventHolder: EventHolder!
    
    var doAfterEdit: ((String,
                       String,
                       String,
                       String,
                       Bool,
                       EventHolderStatus,
                       [EventProtocol]) -> Void)?
    
    // Словарь для eventHolderStatus
    private var statusTitles: [EventHolderStatus : String] = [
        .none : EventHolderStatus.none.rawValue,
        .bestFriend : EventHolderStatus.bestFriend.rawValue,
        .schoolFriend : EventHolderStatus.schoolFriend.rawValue,
        .colleague:  EventHolderStatus.colleague.rawValue,
        .someFriend : EventHolderStatus.someFriend.rawValue ]
    
    // создадим экземпляр UIDatePicker, далее в методе viewDidLoad
    // назначим его как способ ввода в текстовое поле addEventHolderBirthdayDateTextField
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // настроим кнопку "Сохранить"
        saveButtonOutlet.title = "Сохранить"
        // деактивируем ее до тех пор пока все поля не будут заполнены
        saveButtonOutlet.isEnabled = false
        
        // настроим тулбар
        createAndAddingToolBarToKeyboard()
        
        // настроим datePicker
        datePickerSwttings()
        
        // настроим статус по умолчанию
        eventHolderSexLabel.text = "Пол не выбран"
        
        // обновление метки eventHolderStatusLabel в соответствии текущим типом
        eventHolderStatusLabel?.text = statusTitles[currentEventHolderStatus]
        
        // в этом фрагиенте кода проходим по массиву текстовых полей и запускаем для каждого из них
        // наблюдателя .addTarget
        let textFields = [addFirstNameTextField, addSecondNameTextField, addEventHolderPhoneNumberTextField, addEventHolderBirthdayDateTextField]
        for textField in textFields {
            if textField?.isEditing == false{
                // метод addTarget унаследованный от UIControl позволяет выполнять функцию в селекторе #selector()
                // при выполнения условия for: .editingChanged
                textField!.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
                //                textField.addTarget(self, action: #selector(editingBegan(_:)), for: .editingDidBegin)
                //                textField!.addTarget(self, action: #selector(editingEnded(_:)), for: .editingDidEnd)
            }
        }
        
    }
    
    
    // функция проверяет что все поля заполнены и активирует кнопку "Сохранить", если же кнопка была активна
    // и какое либо поле очистили кнопка деактивируется
    @objc func editingChanged(_ textField: UITextField) {
        if saveButtonOutlet.isEnabled == false {
            if !addFirstNameTextField.text!.isEmpty && !addSecondNameTextField.text!.isEmpty && !addEventHolderPhoneNumberTextField.text!.isEmpty && !addEventHolderBirthdayDateTextField.text!.isEmpty {
                saveButtonOutlet.isEnabled.toggle()
            }
        }
        if saveButtonOutlet.isEnabled == true {
            if addFirstNameTextField.text!.isEmpty || addSecondNameTextField.text!.isEmpty || addEventHolderPhoneNumberTextField.text!.isEmpty || addEventHolderBirthdayDateTextField.text!.isEmpty {
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
    
    
    // MARK: - сохранение EventHolder и создание Event
    @IBAction func saveButtonAction(_ sender: UIBarButtonItem) {
        // перед нажатием на кнопку сохранить проверяем заполнены ли поля Пол и Статус
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
    
    // функция либо разрешает либо запрещает редактировать поля в зависимости от статуса
    // кнопки saveButtonOutlet - Сохранить или Изменить
    // а так же создает Юбиляра с событие Birthday по умолчанию и сохраняет его
    // в массив events[]
    func savingOrEditEventHolderAndCreateBirthdayEvent(){
        if saveButtonOutlet.title == "Сохранить" {
            // меняем название кнопки saveButtonOutlet с "Сохранить" на "Изменить"
            self.saveButtonOutlet.title = "Изменить"
            // запрещаем редактировать всех textField
            self.addFirstNameTextField.isEnabled.toggle()
            self.addSecondNameTextField.isEnabled.toggle()
            self.addEventHolderBirthdayDateTextField.isEnabled.toggle()
            self.addEventHolderPhoneNumberTextField.isEnabled.toggle()
            // скрываем клавиатуру
            self.tableView.endEditing(true)
            // скрываем кнопку sexCellButton таким образом запрещаем переход по сигвею по нажатию какбы на ячейку - на самом деле переход
            // осуществляется при помощи прозрачной кнопки
            sexCellButton.isHidden.toggle()
            statusCellButton.isHidden.toggle()
                        
            // для корректного формата даты
            let dateFormatter = DateFormatter()
            // настроим локализацию - для отображения на русском языке
            dateFormatter.locale = Locale(identifier: "ru_RU")
            // настроим вид отображения даты в текстовом виде
            dateFormatter.dateFormat = "d MMMM yyyy"
            
            // создаем новый экземпляр tempEventHolder: EventHolder, потом мы присвоим его eventHolder
            let tempEventHolder = EventHolder(eventHolderFirstName: addFirstNameTextField.text ?? "error",
                                              eventHolderLastName: addSecondNameTextField.text ?? "error",
                                              eventHolderBirthdayDate: dateFormatter.date(from: addEventHolderBirthdayDateTextField.text ?? "11 августа 2011") ?? Date(),
                                              eventHolderPhoneNumber: addEventHolderPhoneNumberTextField.text ?? "error",
                                              sex: currentEventHolderSex,
                                              eventHolderStatus: currentEventHolderStatus,
                                              // добавляем сам ДР
                                              events: [
//                                                Event(eventDate: CustomDate(date: dateFormatter.date(from: addEventHolderBirthdayDateTextField.text ?? "11 августа 2011") ?? Date()),
//                                                      eventType: .birthday,
//                                                      eventDiscription: "описание",
//                                                      isActual: true),
//                                                // еще одно ДР для проверки
                                                Event(eventDate: CustomDate(date: dateFormatter.date(from: addEventHolderBirthdayDateTextField.text ?? "11 августа 2011") ?? Date()),
                                                      eventType: .birthday,
                                                      eventDiscription: "описание",
                                                      isActual: true)
                                              ])
            // теперь присваиваем наше tempEventHolder в постоянное свойство класса eventHolder
            eventHolder = tempEventHolder
            
            // выводим в первую ячейку второй секции данные о дне рождении - первом и автоматически
            // созданном событии Юбиляря
            eventTypeLabel.text = eventHolder.events[0].eventType.rawValue
            countDaysBeforeEventLabel.text = String(eventHolder.events[0].eventDate.daysCountBeforeEvent)
            eventDateLabel.text = dateFormatter.string(from: (eventHolder.events[0].eventDate.date))
            
            tableView.reloadData()
            
        } else {
            if saveButtonOutlet.title == "Изменить" {
                // меняем название кнопки saveButtonOutlet с "Изменить" на "Сохранить"
                self.saveButtonOutlet.title = "Сохранить"
                // разрешаем редактировать всех textField
                self.addFirstNameTextField.isEnabled.toggle()
                self.addSecondNameTextField.isEnabled.toggle()
                self.addEventHolderBirthdayDateTextField.isEnabled = true
                self.addEventHolderPhoneNumberTextField.isEnabled = true
                // скрываем клавиатуру
                self.tableView.endEditing(true)
                // делаем кнопку sexCellButton доступной таким образом разрешаемпереход по сигвею по нажатию
                sexCellButton.isHidden.toggle()
                statusCellButton.isHidden.toggle()
            }
        }
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 6
        }
        
        if section == 1 {
            if eventHolder == nil {
                return 0
            } else {
                return eventHolder.events.count
            }
        }
        
        if section == 2 {
            if eventHolder == nil {
                return 0
            } else {
                return 1
            }
        }
        return 0
    }
    
    // MARK: - Navigation
    // при переходе с экрана AddEventHolderTableViewController на ChangeEventHolderStatusTableViewController
    // при помощи сегвея с Id - "toChangeEventHolderStatusTableViewControllerId" реализуем передачу данных
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toChangeEventHolderStatusTableViewControllerId" {
            
            // ссылка на контроллер назначения
            let destination = segue.destination as! ChangeEventHolderStatusTableViewController
            
            // передача текущего статуса, при первом переходе статус всегда будет - .none
            destination.selectedStatus = currentEventHolderStatus
            
            // передача обработчика выбора статуса
            // doAfterStatusSelected является свойством-замыканием у которого есть тело-замыкание( тело функции),
            // передаем(присваеваем) ему это тело-реализацию функции, после этого в свойстве doAfterStatusSelected будет
            // храниться реализация замыкания(функции), и когда в будущем к этому свойству doAfterStatusSelected будут обращаться
            // функция будет выполняться
            destination.doAfterStatusSelected = { [self] selectedStatus in
                // изменяем статус пользователя в контроллере AddEventHolderTableViewController
                self.currentEventHolderStatus = selectedStatus
                // обновляем метку с текущим типом в AddEventHolderTableViewController
                eventHolderStatusLabel?.text = statusTitles[currentEventHolderStatus]
                
                // таким образом мы выполнили операции в AddEventHolderTableViewController при помощи замыкания doAfterStatusSelected вызвав его
                // вообще в другом контроллере
            }
        }
        
        if segue.identifier == "toChangeEventHolderSexTableViewControllerId" {
            let destination = segue.destination as! ChangeEventHolderSexTableViewController
            destination.selectedSex = currentEventHolderSex
            destination.doAfterSexSelected = {[self] selectedSex in
                self.currentEventHolderSex = selectedSex
                eventHolderSexLabel.text = currentEventHolderSex.rawValue
            }
        }
    }
    
    
    // MARK: - настройка ToolBar вызывается во viewDidLoad
    
    // функция будет настраивать ToolBar и кнопку Done для скрытия клавиатуры
    func createAndAddingToolBarToKeyboard() {
        // создадим Тулбар, позже расположим его над клавиатурой
        let toolBar = UIToolbar()
        //
        toolBar.sizeToFit()
        // добавим на ТулБар кнопку Готово
        // создадим кнопку
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(doneAction))
        
        // создадим "поле-пробел" что бы заполнить им пространство слева на ТулБаре
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // подключим кнопку к тулБару и настроим положение кнопки Готово на Тулбаре - справа
        toolBar.setItems([flexSpace, doneButton], animated: true)
        
        // подключаем созданный ТулБар ко всем текстовым полям
        addFirstNameTextField.inputAccessoryView = toolBar
        addSecondNameTextField .inputAccessoryView = toolBar
        addEventHolderPhoneNumberTextField.inputAccessoryView = toolBar
        addEventHolderBirthdayDateTextField.inputAccessoryView = toolBar
    }
    
    
    // MARK: - настройка DateDicker
    
    //вызывается во viewDidLoad
    func datePickerSwttings() {
        
        // и назначим datePicker способом ввода в текстовое поле
        addEventHolderBirthdayDateTextField.inputView = datePicker
        // назначим стиль - колесики
        datePicker.preferredDatePickerStyle = .wheels
        // установим первое значение на текущую дату
        datePicker.datePickerMode = .date
        // установим текущую дату максимальным значеним на datePicker
        datePicker.maximumDate = .now
        // чтобы значения в addEventHolderBirthdayDateTextField менялись при прокручивании колесика datePicker "повесим событие" на datePicker
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        // настроим формат отображения даты в соответствии с языковыми настройками айфона пользователя
        let localeID = Locale.preferredLanguages.first
        datePicker.locale = Locale(identifier: localeID!)
    }
    
    // Создадим функцию которая будет возвращать дату в нужном формате и передавать ее в текстовом виде в текстовое поле
    func getDateFromPicker() {
        // создадим экземпляр типа DateFormatter
        let formater = DateFormatter()
        // настроим локализацию - для отображения на русском языке
        formater.locale = Locale(identifier: "ru_RU")
        // настроим вид отображения даты в текстовом виде
        formater.dateFormat = "d MMMM yyyy"
        // передадим в текстовое поле dateField строку обработанное форматером принятое от datePicker
        addEventHolderBirthdayDateTextField.text = formater.string(from: datePicker.date)
    }
    
    // при изменении значений на datePicker будет обновлять dateField
    @objc func dateChanged (){
        getDateFromPicker()
    }
    
    // при нажатии на кнопку Готово на тулбаре скрывает клавиатуру
    @objc func doneAction (){
        self.tableView.endEditing(true)
    }
    
}
