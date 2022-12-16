//
//  AddEventViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 28.08.2022.
//

import UIKit

class AddEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var tableView: UITableView!
    
    // свойство для загрузки в него хранилища с данными
    var eventsStorage : EventStorageProtocol = EventStorage()
    //
    var currentEventsHolder : EventHolder!
    
    // Значение для хранения высоты клавиатуры
    var currentKbHight = CGFloat(0)
    
    // ячейки
    var eventTypeCell: UITableViewCell!
    var eventDateCell: UITableViewCell!
    
    // наполнение ячеек
    var eventTypeLabel: UILabel!
    var eventDateTextField: UITextField!
    
    // вью в котором находится UITextView и лейбл
    var someView: UIView!
    // тектовое вью для описания события
    var eventDescriptionTextView: UITextView!
    
    // кнопка сохранить
    var saveButton: UIButton!
    
    // переменная для хранения текущего статуса Юбиляра
    var currentEventType: EventType = .none
    
    // создадим экземпляр UIDatePicker, далее в методе viewDidLoad
    // назначим его как способ ввода в текстовое поле eventDateTextField
    var datePicker = UIDatePicker()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // настройка и верстка всего экрана
        settings()

        // настройка большого navigationItem.title в DetailedEventViewController
        self.navigationItem.largeTitleDisplayMode = .never
        
        // получим актуальный список [EventHolder] в хранилище eventsStorage
        eventsStorage.getUpdatedDataToEventStorage()
        
        eventDateTextField.text = ""
        
        // укажем в лейбле eventTypeLabel значенеие по умолчанию
        eventTypeLabel.text = currentEventType.rawValue
        
        // настроим datePicker
        datePickerSettings()

    }
  
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        
        // отменим eventDescriptionTextView и eventDateTextField первым ответчиком
        // для того чтобы всегда при уходе с экрана пропадала клавиатура
        eventDescriptionTextView.resignFirstResponder()
        eventDateTextField.resignFirstResponder()
    }
    
    // MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        // получим актуальный список [EventHolder] в хранилище eventsStorage
        eventsStorage.getUpdatedDataToEventStorage()
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    // настройка высоты ячеек в данамической таблице
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 { return 50 }
        if indexPath.section == 0 && indexPath.row == 1 { return 50 }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.section == 0 && indexPath.row == 0 {
            return eventTypeCell
        }
        if indexPath.section == 0 && indexPath.row == 1 {
            return eventDateCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            let selectEventTypeTableViewController = SelectEventTypeTableViewController()
            // передача текущего статуса, при первом переходе статус всегда будет - .none
            selectEventTypeTableViewController.selectedEventType = currentEventType
            
            // передача обработчика выбора статуса
            // doAfterEventTypeSelected является свойством-замыканием у которого есть тело-замыкание( тело функции),
            // передаем(присваеваем) ему это тело-реализацию функции, после этого в свойстве doAfterEventTypeSelected будет
            // храниться реализация замыкания(функции), и когда в будущем к этому свойству doAfterEventTypeSelected будут обращаться
            // функция будет выполняться
            selectEventTypeTableViewController.doAfterEventTypeSelected = { [self] selectedEventType in
                // изменяем статус пользователя в контроллере AddEventHolderTableViewController
                self.currentEventType = selectedEventType
                // обновляем метку с текущим типом в AddEventTableViewController
                eventTypeLabel.text = currentEventType.rawValue
                
                // таким образом мы выполнили операции в AddEventHolderTableViewController при помощи замыкания doAfterStatusSelected вызвав его
                // в SelectEventTypeTableViewController
            }
            self.navigationController?.pushViewController(selectEventTypeTableViewController, animated: true)
            print("push")
        }
        
        if indexPath.section == 0 && indexPath.row == 1 {
            eventDateTextField.becomeFirstResponder()
            
        }
    }
}


// MARK: - настройка DateDicker
extension AddEventViewController {
    
    //вызывается во viewDidLoad
    func datePickerSettings() {
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
        // передадим в текстовое поле dateField строку обработанное форматером принятое от datePicker
        eventDateTextField.text = formater.string(from: datePicker.date)
        // tableView.reloadData()
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
    
    // при изменении значений на datePicker будет обновлять dateField
    @objc func dateChanged() {
        getDateFromPicker()
    }
    
}


// MARK: - ограничения для textView
extension AddEventViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (eventDescriptionTextView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 65    // 65 Limit Value
    }
}


// MARK: верстка всего
extension AddEventViewController {
    
    func settings() {
        
        view.backgroundColor = .systemGray6
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.maxX, height: 240), style: .insetGrouped)
        tableView.isScrollEnabled = false
        
        self.view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        eventTypeCell = {
            let eventTypeCell = UITableViewCell()
            eventTypeCell.accessoryType = .disclosureIndicator
            eventTypeCell.selectionStyle = .none
            
            // левый лейбл
            let eventTypeDescriptionLabel = UILabel()
            eventTypeDescriptionLabel.text = "Событие"
            eventTypeDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            eventTypeCell.addSubview(eventTypeDescriptionLabel)
            NSLayoutConstraint.activate([eventTypeDescriptionLabel.centerYAnchor.constraint(equalTo: eventTypeCell.centerYAnchor),
                                         eventTypeDescriptionLabel.heightAnchor.constraint(equalToConstant: 60),
                                         eventTypeDescriptionLabel.leadingAnchor.constraint(equalTo: eventTypeCell.leadingAnchor, constant: 20)])
            // правый лейбл
            eventTypeLabel = UILabel()
            eventTypeLabel.translatesAutoresizingMaskIntoConstraints = false
            eventTypeCell.addSubview(eventTypeLabel)
            NSLayoutConstraint.activate([eventTypeLabel.centerYAnchor.constraint(equalTo: eventTypeCell.centerYAnchor),
                                         eventTypeLabel.heightAnchor.constraint(equalToConstant: 60),
                                         eventTypeLabel.trailingAnchor.constraint(equalTo: eventTypeCell.trailingAnchor, constant: -40)])
            eventTypeLabel.textColor = .systemGray
            return eventTypeCell
        }()
        
        eventDateCell = {
            let eventDateCell = UITableViewCell(frame: .zero)
            eventDateCell.selectionStyle = .none
            
            // левый лейбл
            let eventTypeDescriptionLabel = UILabel(frame: .zero)
            eventTypeDescriptionLabel.text = "Дата"
            eventTypeDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            eventDateCell.addSubview(eventTypeDescriptionLabel)
            
            NSLayoutConstraint.activate([eventTypeDescriptionLabel.centerYAnchor.constraint(equalTo: eventDateCell.centerYAnchor),
                                         eventTypeDescriptionLabel.heightAnchor.constraint(equalToConstant: 90),
                                         eventTypeDescriptionLabel.leadingAnchor.constraint(equalTo: eventDateCell.leadingAnchor, constant: 20)])
            // правый eventDateTextField
            eventDateTextField = UITextField()
            eventDateTextField.translatesAutoresizingMaskIntoConstraints = false
            eventDateCell.addSubview(eventDateTextField)
            NSLayoutConstraint.activate([eventDateTextField.centerYAnchor.constraint(equalTo: eventDateCell.centerYAnchor),
                                         eventDateTextField.heightAnchor.constraint(equalToConstant: 90),
                                         eventDateTextField.leadingAnchor.constraint(equalTo: eventTypeDescriptionLabel.trailingAnchor, constant: 0),
                                         eventDateTextField.trailingAnchor.constraint(equalTo: eventDateCell.trailingAnchor, constant: -20)])
            eventDateTextField.placeholder = "установите дату"
            eventDateTextField.textAlignment = .right
            
            return eventDateCell
            
        }()
        
        someView = {
            let someView = UIView(frame: .zero)
            someView.layer.cornerRadius = 10
            someView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(someView)
            someView.clipsToBounds = true
            NSLayoutConstraint.activate([someView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                         someView.heightAnchor.constraint(equalToConstant: 80),
                                         someView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0),
                                         someView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                         someView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)])
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            someView.addSubview(label)
            NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: someView.centerXAnchor),
                                         label.heightAnchor.constraint(equalToConstant: 30),
                                         label.topAnchor.constraint(equalTo: someView.topAnchor, constant: 0),
                                         label.leadingAnchor.constraint(equalTo: someView.leadingAnchor, constant: 0),
                                         label.trailingAnchor.constraint(equalTo: someView.trailingAnchor, constant: 0)])
            label.text = " Описание"
            label.backgroundColor = .white
            
            return someView
        }()
        
        eventDescriptionTextView = {
            let eventDescriptionTextView = UITextView(frame: .zero)
            //eventDescriptionTextView.layer.cornerRadius = 10
            eventDescriptionTextView.font = .preferredFont(forTextStyle: .body, compatibleWith: .none)
            // eventDescriptionTextView.font?.withSize(30)
            eventDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
            someView.addSubview(eventDescriptionTextView)
            NSLayoutConstraint.activate([eventDescriptionTextView.heightAnchor.constraint(equalToConstant: 55),
                                         eventDescriptionTextView.bottomAnchor.constraint(equalTo: someView.bottomAnchor, constant: 0),
                                         
                                         eventDescriptionTextView.leadingAnchor.constraint(equalTo: someView.leadingAnchor, constant: 0),
                                         eventDescriptionTextView.trailingAnchor.constraint(equalTo: someView.trailingAnchor, constant: 0)])
            
            // eventDescriptionTextView.layer.backgroundColor = UIColor.green.cgColor
            return eventDescriptionTextView
            
        }()
        
        // назначаем делегат для eventDescriptionTextView
        eventDescriptionTextView.delegate = self
        // назначаем делегат для eventDateTextField
        eventDateTextField.delegate = self
        
        
        saveButton = {
            let saveButton = UIButton(frame: .zero)
            saveButton.layer.cornerRadius = 10
            saveButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(saveButton)
            NSLayoutConstraint.activate([saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                         saveButton.heightAnchor.constraint(equalToConstant: 45),
                                         saveButton.topAnchor.constraint(equalTo: someView.bottomAnchor, constant: 20),
                                         saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                         saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)])
            saveButton.layer.backgroundColor = UIColor(red: 0.28, green: 0.52, blue: 0.80, alpha: 1.00).cgColor
            saveButton.setTitle("Сохранить", for: .normal)
            
            saveButton.addAction(UIAction(handler: { [self]_ in

                let newEvent = Event(eventDate: getDateFromTextField(),
                                             eventType: EventType(rawValue: eventTypeLabel.text ?? "тип события не выбран") ?? .none,
                                             eventDiscription: eventDescriptionTextView.text,
                                             isActual: true)
                
                        self.navigationController?.viewControllers.forEach{ viewController in
                            // добавляем событие в массив-датасурс предыдущего контроллера и обновим его
                            (viewController as? AddEventHolderViewController)?.eventHolder.events.append(newEvent)
                            //(viewController as? ShowAllEventsOfSomeHolderTableViewController)?.tableView.reloadData()
                        }
                
                        // добавляем событие в хранилище
                        eventsStorage.addEventToExistedHolder(addingEvent: newEvent, existedHolder: currentEventsHolder)
                        // (viewController as? StartTableViewController)?.tableView.reloadData()
                        navigationController?.popViewController(animated: true)

            }), for: .touchUpInside)
            
            return saveButton
            
        }()
        
    }
}


