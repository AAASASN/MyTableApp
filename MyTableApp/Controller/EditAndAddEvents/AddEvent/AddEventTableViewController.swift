//
//  AddEventTableViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 28.08.2022.
//

import UIKit

class AddEventTableViewController: UITableViewController {

    
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var eventDateTextField: UITextField!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    
    // переменная для хранения текущего статуса Юбиляра
    var currentEventType: EventType = .none
    
    // создадим экземпляр UIDatePicker, далее в методе viewDidLoad
    // назначим его как способ ввода в текстовое поле eventDateTextField
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // укажем в лейбле eventTypeLabel значенеие по умолчанию
        eventTypeLabel.text = currentEventType.rawValue
        
        // настроим datePicker
        datePickerSettings()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (eventTypeLabel.text == "тип события не выбран" ? 1 : 2)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var letForReturn = 0
        letForReturn = (section == 0 ? 3 : 1)
        return letForReturn
    }
    
    // MARK: - Navigation
    // при переходе с экрана AddEventTableViewController на SelectEventTypeTableViewController
    // при помощи сегвея с Id - "toSelectEventTypeTableViewControllerId" реализуем передачу данных
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSelectEventTypeTableViewControllerId" {
            
            // ссылка на контроллер назначения
            let destination = segue.destination as! SelectEventTypeTableViewController
            
            // передача текущего статуса, при первом переходе статус всегда будет - .none
            destination.selectedEventType = currentEventType
            
            // передача обработчика выбора статуса
            // doAfterEventTypeSelected является свойством-замыканием у которого есть тело-замыкание( тело функции),
            // передаем(присваеваем) ему это тело-реализацию функции, после этого в свойстве doAfterEventTypeSelected будет
            // храниться реализация замыкания(функции), и когда в будущем к этому свойству doAfterEventTypeSelected будут обращаться
            // функция будет выполняться
            destination.doAfterEventTypeSelected = { [self] selectedEventType in
                // изменяем статус пользователя в контроллере AddEventHolderTableViewController
                self.currentEventType = selectedEventType
                // обновляем метку с текущим типом в AddEventTableViewController
                eventTypeLabel?.text = currentEventType.rawValue
                
                // таким образом мы выполнили операции в AddEventHolderTableViewController при помощи замыкания doAfterStatusSelected вызвав его
                // вообще в другом контроллере
                
                // обновим таблицу для отображения кнопки "Сохранить" во второй секции
                tableView.reloadData()
            }
        }
    }
    
    
    
    // MARK: - настройка DateDicker
    
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
    }
    
    // Создадим функцию которая будет брать дату их текстового поля и возвращать дату формате CustomDate
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
    @objc func dateChanged (){
        getDateFromPicker()
        // обновим таблицу для отображения кнопки "Сохранить" во второй секции
        tableView.reloadData()
    }
    
    // при нажатии на кнопку Готово на тулбаре скрывает клавиатуру
    @objc func doneAction (){
        self.tableView.endEditing(true)
    }
    
    // при нажатии на ячейку во второй секции будет создаватся Event и передаваться на предыдущий экран
    // (ShowAllEventsOfSomeHolderTableViewController) в
    // массиве navigationController?.viewControllers.events, затем таблица предыдущего экрана обновляется
    // и предыдущей экран открывается
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            let newEvent = Event(eventDate: getDateFromTextField(),
                                 eventType: EventType(rawValue: eventTypeLabel.text ?? "тип события не выбран") ?? .none,
                                 eventDiscription: eventDescriptionTextView.text,
                                 isActual: true)
            self.navigationController?.viewControllers.forEach{ viewController in
                (viewController as? ShowAllEventsOfSomeHolderTableViewController)?.events.append(newEvent)
                (viewController as? ShowAllEventsOfSomeHolderTableViewController)?.tableView.reloadData()
                // так же добавляем это событие в eventHolder.events на экране AddEventHolderTableViewController
                // и указываем количество событий пользователя в лейбле AddEventHolderTableViewController.eventCountLabel.text
                (viewController as? AddEventHolderTableViewController)?.eventHolder.events.append(newEvent)
                let eventCount = (viewController as? AddEventHolderTableViewController)?.eventHolder.events.count
                (viewController as? AddEventHolderTableViewController)?.eventCountLabel.text =  String(eventCount ?? 9999)
            }
            navigationController?.popViewController(animated: true)
        }
        
    }
}
