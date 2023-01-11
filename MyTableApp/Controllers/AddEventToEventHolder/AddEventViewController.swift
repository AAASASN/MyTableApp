//
//  AddEventViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 28.08.2022.
//

import UIKit

class AddEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var tableView: UITableView!
    
    // кнопка сохранить
    var saveBarButtonItem: UIBarButtonItem!
    
    // ячейка eventTypeCell и ее лейблы
    var eventTypeCell: UITableViewCell!
    var eventTypeLabel: UILabel!
    
    // ячейка eventDateCell и ее лейбл текстфилд
    var eventDateCell: UITableViewCell!
    var eventDateTextField: UITextField!
    
    // ячейка eventDescriptionCell и ее лейбел
    var eventDescriptionCell: UITableViewCell!
    // лейбл для описания события
    var eventDescriptionLabel: UILabel!
    
    // создадим экземпляр UIDatePicker, далее
    // назначим его как способ ввода в текстовое поле eventDateTextField
    var datePicker: UIDatePicker!
    
    // свойство для загрузки в него хранилища с данными
    var eventsStorage : EventStorageProtocol = EventStorage()
    //
    var currentEventsHolder : EventHolder!
    // переменная для хранения текущего статуса события
    var currentEventType: EventType = .none
    
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.backgroundColor = .systemGray6
        self.navigationItem.title = "Добавить событие"
        
        view.backgroundColor = .systemGray4
        
        // настройка и верстка всего экрана
        settings()
        
        // настроим datePicker
        datePickerSettings()
        
        // получим актуальный список [EventHolder] в хранилище eventsStorage
        eventsStorage.getUpdatedDataToEventStorage()
                
        // укажем в лейбле eventTypeLabel значенеие по умолчанию
        eventTypeLabel.text = currentEventType.rawValue
        
        tableView.delegate = self
        tableView.dataSource = self
        eventDateTextField.delegate = self
        
    }
  
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        
        // resign eventDateTextField первым ответчиком
        // для того чтобы всегда при уходе с экрана пропадала клавиатура
        eventDateTextField.resignFirstResponder()
    }
    
    // MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        // получим актуальный список [EventHolder] в хранилище eventsStorage
        eventsStorage.getUpdatedDataToEventStorage()
        
        tableView.reloadData()
    }
    
    
    // MARK: - presentEventDescriptionInputAlertController
    func presentEventDescriptionInputAlertController() {
        
        let dateInputAlertController = UIAlertController(title: "Описание события", message: nil, preferredStyle: .alert)
        dateInputAlertController.addTextField()
        dateInputAlertController.textFields?[0].text = eventDescriptionLabel.text
        dateInputAlertController.textFields?[0].clearButtonMode = .always
        let saveAction = UIAlertAction(title: "Добавить", style: .default) { _ in
            self.tableView.endEditing(true)
            guard let text = dateInputAlertController.textFields?[0].text else { return }
            self.eventDescriptionLabel.text = text
            
            // активируем или деактиаируем кнопку "Сохранить"
            self.activateSaveBarButtonItemIfAllCellsIsNotEmpty()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        dateInputAlertController.addAction(cancelAction)
        dateInputAlertController.addAction(saveAction)
        self.present(dateInputAlertController, animated: true)

    }
}

// MARK: - Table view dataSource and Delegate
extension AddEventViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.section == 0 && indexPath.row == 0 {
            return eventTypeCell
        }
        if indexPath.section == 1 && indexPath.row == 0 {
            // eventDateCell.tex
            return eventDateCell
        }
        if indexPath.section == 2 && indexPath.row == 0 {
            return eventDescriptionCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0  { return "тип события" }
        if section == 1  { return "дата"  }
        if section == 2  { return "описание события" }
        return "XXXXX"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.endEditing(true)
        if indexPath.section == 0 && indexPath.row == 0 {
            let selectEventTypeViewController = SelectEventTypeViewController()
            // передача текущего статуса, при первом переходе статус всегда будет - .none
            selectEventTypeViewController.selectedEventType = currentEventType
            
            selectEventTypeViewController.doAfterEventTypeSelected = { [self] selectedEventType in
                // изменяем статус пользователя в контроллере AddEventHolderViewController
                self.currentEventType = selectedEventType
                // обновляем метку с текущим типом в AddEventViewController
                eventTypeLabel.text = currentEventType.rawValue
                
                // активируем или деактиаируем кнопку "Сохранить"
                activateSaveBarButtonItemIfAllCellsIsNotEmpty()
                
                // меняем цвет текста на черный
                if selectedEventType != EventType.none {
                    eventTypeLabel.textColor = .black
                } else { eventTypeLabel.textColor = .systemGray3 }
            }
            self.navigationController?.pushViewController(selectEventTypeViewController, animated: true)
            print("push")
        }
        
        if indexPath.section == 1 && indexPath.row == 0 {
            eventDateTextField.becomeFirstResponder()
        }
        
        if indexPath.section == 2 && indexPath.row == 0 {
            presentEventDescriptionInputAlertController()
        }
        
    }
}

// MARK: - настройка DateDicker
extension AddEventViewController {
    
    //вызывается во viewDidLoad
    func datePickerSettings() {
        
        datePicker = UIDatePicker()
        
        // и назначим datePicker способом ввода в текстовое поле
        eventDateTextField.inputView = datePicker
        
        
        // назначим стиль - колесики
        datePicker.preferredDatePickerStyle = .wheels
        // установим первое значение на текущую дату
        datePicker.datePickerMode = .date
        // установим текущую дату максимальным значеним на datePicker
        datePicker.maximumDate = .now
        
        // чтобы значения в eventDateTextField менялись при прокручивании колесика datePicker "повесим событие" на datePicker
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
        // передадим в текстовое поле eventDateTextField строку обработанное форматером принятое от datePicker
        eventDateTextField.text = formater.string(from: datePicker.date)
        
        // активируем или деактиаируем кнопку "Сохранить"
        activateSaveBarButtonItemIfAllCellsIsNotEmpty()
    }
    
    // Создадим функцию которая будет брать дату из текстового поля и возвращать дату формате CustomDate
    func getDateFromTextField() -> CustomDate {
        // создадим экземпляр типа DateFormatter
        let formater = DateFormatter()
        // настроим локализацию - для отображения на русском языке
        formater.locale = Locale(identifier: "ru_RU")
        // настроим вид отображения даты в текстовом виде
        formater.dateFormat = "d MMMM yyyy"
        // создадим экземпляр CustomDate
        let customDate = CustomDate(date: formater.date(from: eventDateTextField.text ?? "1 января 2000") ?? Date())
        return customDate
    }
    
    // при изменении значений на datePicker будет обновлять eventDateTextField
    @objc func dateChanged() {
        getDateFromPicker()
    }
    
}


// MARK: - верстка и настройка всего
extension AddEventViewController {
    
    func settings() {
                
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.maxX, height: self.view.bounds.maxY), style: .insetGrouped)
        tableView.isScrollEnabled = false
     
        // eventTypeCell
        eventTypeCell = {
            let eventTypeCell = UITableViewCell()
            eventTypeCell.accessoryType = .disclosureIndicator
            eventTypeCell.selectionStyle = .none
            return eventTypeCell
        }()

        // правый лейбл eventTypeCell
        eventTypeLabel = {
            let eventTypeLabel = UILabel()
            eventTypeLabel.translatesAutoresizingMaskIntoConstraints = false
            eventTypeLabel.textColor = .systemGray3
            eventTypeLabel.textAlignment = .left
            return eventTypeLabel
        }()
        
        // eventDateCell
        eventDateCell = {
            let eventDateCell = UITableViewCell(frame: .zero)
            eventDateCell.selectionStyle = .none
            return eventDateCell
        }()
        
        // eventDateTextField в eventDateCell
        eventDateTextField = {
            let eventDateTextField = UITextField(frame: .zero)
            eventDateTextField.translatesAutoresizingMaskIntoConstraints = false
            eventDateTextField.placeholder = "установите дату"
            eventDateTextField.textAlignment = .left
            return eventDateTextField
        }()
        
        // eventDescriptionCell
        eventDescriptionCell = {
            let eventDescriptionCell = UITableViewCell(frame: .zero)
            eventDescriptionCell.selectionStyle = .none
            return eventDescriptionCell
        }()

        eventDescriptionLabel = {
            let eventDescriptionLabel = UILabel(frame: .zero)
            eventDescriptionLabel.textAlignment = .left
            eventDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            return eventDescriptionLabel
        }()
     
        saveBarButtonItem = {
            let saveButton = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveButtonAction))
            saveButton.isEnabled = false
            self.navigationItem.rightBarButtonItem = saveButton
            
            return saveButton
            
        }()
        
        
        // иерархия всеx элементов
        view.addSubview(tableView)
        eventTypeCell.addSubview(eventTypeLabel)
        eventDateCell.addSubview(eventDateTextField)
        eventDescriptionCell.addSubview(eventDescriptionLabel)
                
        // Настройка автолайаута
        NSLayoutConstraint.activate([
            
            //
            eventTypeLabel.heightAnchor.constraint(equalToConstant: 60),
            eventTypeLabel.topAnchor.constraint(equalTo: eventTypeCell.topAnchor, constant: 0),
            eventTypeLabel.leadingAnchor.constraint(equalTo: eventTypeCell.leadingAnchor, constant: 20),
            eventTypeLabel.trailingAnchor.constraint(equalTo: eventTypeCell.trailingAnchor, constant: 0),
            eventTypeLabel.bottomAnchor.constraint(equalTo: eventTypeCell.bottomAnchor, constant: 0),

            //
            eventDateTextField.heightAnchor.constraint(equalToConstant: 60),
            eventDateTextField.topAnchor.constraint(equalTo: eventDateCell.topAnchor, constant: 0),
            eventDateTextField.leadingAnchor.constraint(equalTo: eventDateCell.leadingAnchor, constant: 20),
            eventDateTextField.trailingAnchor.constraint(equalTo: eventDateCell.trailingAnchor, constant: 0),
            eventDateTextField.bottomAnchor.constraint(equalTo: eventDateCell.bottomAnchor, constant: 0),

            //
            eventDescriptionLabel.heightAnchor.constraint(equalToConstant: 60),
            eventDescriptionLabel.topAnchor.constraint(equalTo: eventDescriptionCell.topAnchor, constant: 0),
            eventDescriptionLabel.leadingAnchor.constraint(equalTo: eventDescriptionCell.leadingAnchor, constant: 20),
            eventDescriptionLabel.trailingAnchor.constraint(equalTo: eventDescriptionCell.trailingAnchor, constant: 0),
            eventDescriptionLabel.bottomAnchor.constraint(equalTo: eventDescriptionCell.bottomAnchor, constant: 0),
        ])
    }
    
    // отработка нажатия на кнопку "Сохранить"
    @objc
    func saveButtonAction() {
        let newEvent = Event(eventDate: getDateFromTextField(),
                            eventType: EventType(rawValue: eventTypeLabel.text ?? "тип события не выбран") ?? .none,
                            eventDiscription: eventDescriptionLabel.text ?? "error",
                            isActual: true)

                self.navigationController?.viewControllers.forEach{ viewController in

                    // добавляем событие в массив-датасурс предыдущего контроллера и обновим его
                    (viewController as? AddEventHolderViewController)?.eventHolder.events.append(newEvent)
                }

                // добавляем событие в хранилище
                eventsStorage.addEventToExistedHolder(addingEvent: newEvent, existedHolder: currentEventsHolder)
                navigationController?.popViewController(animated: true)
    }
}


// MARK: - активируем или деактиаируем кнопку "Сохранить"
extension AddEventViewController {
    func activateSaveBarButtonItemIfAllCellsIsNotEmpty() {
        
        if saveBarButtonItem.isEnabled == false {
            if (eventTypeLabel.text != "тип события не выбран") &&
                (eventDateTextField.text?.isEmpty == false) &&
                (eventDescriptionLabel.text?.isEmpty == false) {
                saveBarButtonItem.isEnabled = true
            }
        }
        
        if saveBarButtonItem.isEnabled == true {
            if !(eventTypeLabel.text != "тип события не выбран") { saveBarButtonItem.isEnabled = false }
            // if (eventDateTextField.text?.isEmpty == true) { saveBarButtonItem.isEnabled = false }
            if (eventDescriptionLabel.text?.isEmpty == true) { saveBarButtonItem.isEnabled = false }
        }
    }
}
