//
//  AddEventTableViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 28.08.2022.
//

import UIKit

class AddEventTableViewController: UITableViewController {

    // свойство для загрузки в него хранилища с данными
    var eventsStorage : EventStorageProtocol = EventStorage()
    //
    var currentEventsHolder : EventHolder!
    
    // Значение для хранения высоты клавиатуры
    var currentKbHight = CGFloat(0)
    
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
        
        // настройка большого navigationItem.title в DetailedEventViewController
        self.navigationItem.largeTitleDisplayMode = .never
        

        // получим актуальный список [EventHolder] в хранилище eventsStorage
        eventsStorage.getUpdatedDataToEventStorage()
        
        eventDateTextField.text = ""
        
        eventDescriptionTextView.becomeFirstResponder()
        
        // укажем в лейбле eventTypeLabel значенеие по умолчанию
        eventTypeLabel.text = currentEventType.rawValue
        
        // настроим datePicker
        datePickerSettings()
        
        // настроим тулбар
        createAndAddingToolBarToKeyboard()
        
        // вызываем метод который будет регистрировать наблюдателей
        registerForKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // получим актуальный список [EventHolder] в хранилище eventsStorage
        eventsStorage.getUpdatedDataToEventStorage()
        
        tableView.reloadData()
        
        
        // сделаем eventDescriptionTextView первым ответчиком для того чтобы всегда при загрузке
        // экрана появлялась клавиатура
//        eventDescriptionTextView.becomeFirstResponder()
        eventDateTextField.becomeFirstResponder()

        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        let varForReturn = 1
//        if eventDateTextField.text != "" && eventTypeLabel.text != "тип события не выбран" && eventDescriptionTextView.text != "" {
//            varForReturn = 2
//        }
        return varForReturn
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let letForReturn = 3
//        letForReturn = (section == 0 ? 3 : 1)
        return letForReturn
    }
    
    
    // настройка высоты ячеек в данамической таблице
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 { return 50 }
        if indexPath.section == 0 && indexPath.row == 1 { return 50 }
        
        // получаем доступ к текущему окну
        let window = UIApplication.shared.windows[0]
        // определяем отступ сверху от границ окна до Safe Area
        let topPadding = window.safeAreaInsets.top
        // устанавливаем координату Y кнопки в соответствии с отступом button.frame.origin.y = topPadding
        
//        return tableView.frame.height - topPadding - 255 - currentKbHight
        return tableView.frame.height - 255 - currentKbHight

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
                eventTypeLabel?.text = currentEventType.rawValue
                
                // таким образом мы выполнили операции в AddEventHolderTableViewController при помощи замыкания doAfterStatusSelected вызвав его
                // вообще в другом контроллере
        }
            self.navigationController?.pushViewController(selectEventTypeTableViewController, animated: true)
            print("push")
    }
    
//    // MARK: - нажатие на кнопку сохранить (она же ячейка во второй секции)
//    // при нажатии на ячейку во второй секции будет создаватся Event и передаваться на предыдущий экран
//    // (AddEventHolderViewController) в массиве navigationController?.viewControllers.events, затем таблица предыдущего экрана обновляется
//    // и предыдущей экран открывается
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 1 && indexPath.row == 0 {
//            let newEvent = Event(eventDate: getDateFromTextField(),
//                                 eventType: EventType(rawValue: eventTypeLabel.text ?? "тип события не выбран") ?? .none,
//                                 eventDiscription: eventDescriptionTextView.text,
//                                 isActual: true)
//
//            self.navigationController?.viewControllers.forEach{ viewController in
//                // добавляем событие в массив-датасурс предыдущего контроллера и обновим его
//                (viewController as? AddEventHolderViewController)?.eventHolder.events.append(newEvent)
//                //(viewController as? ShowAllEventsOfSomeHolderTableViewController)?.tableView.reloadData()
//            }
//
//            // добавляем событие в хранилище
//            eventsStorage.addEventToExistedHolder(addingEvent: newEvent, existedHolder: currentEventsHolder)
//            // (viewController as? StartTableViewController)?.tableView.reloadData()
//            navigationController?.popViewController(animated: true)
//        }
//    }
    
    
    
    // MARK: - Navigation
    // при переходе с экрана AddEventTableViewController на SelectEventTypeTableViewController
    // при помощи сегвея с Id - "toSelectEventTypeTableViewControllerId" реализуем передачу данных
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "toSelectEventTypeTableViewControllerId" {
//
//            // ссылка на контроллер назначения
//            let destination = segue.destination as! SelectEventTypeTableViewController
//
//            // передача текущего статуса, при первом переходе статус всегда будет - .none
//            destination.selectedEventType = currentEventType
//
//            // передача обработчика выбора статуса
//            // doAfterEventTypeSelected является свойством-замыканием у которого есть тело-замыкание( тело функции),
//            // передаем(присваеваем) ему это тело-реализацию функции, после этого в свойстве doAfterEventTypeSelected будет
//            // храниться реализация замыкания(функции), и когда в будущем к этому свойству doAfterEventTypeSelected будут обращаться
//            // функция будет выполняться
//            destination.doAfterEventTypeSelected = { [self] selectedEventType in
//                // изменяем статус пользователя в контроллере AddEventHolderTableViewController
//                self.currentEventType = selectedEventType
//                // обновляем метку с текущим типом в AddEventTableViewController
//                eventTypeLabel?.text = currentEventType.rawValue
//
//                // таким образом мы выполнили операции в AddEventHolderTableViewController при помощи замыкания doAfterStatusSelected вызвав его
//                // вообще в другом контроллере
//
//                // обновим таблицу для отображения кнопки "Сохранить" во второй секции
//                tableView.reloadData()
//            }
//        }
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
    
    // при нажатии на кнопку Сохранить на тулбаре будет сохраняться
    // событие и будет происходить переход на предыдущий экран
    @objc func saveAction (){
        
        
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
        
        //self.tableView.endEditing(true)
    }
    
    // MARK: - настройка ToolBar вызывается во viewDidLoad
    // функция будет настраивать ToolBar и кнопку Done для скрытия клавиатуры
    func createAndAddingToolBarToKeyboard() {
        
        // создадим Тулбар
        let toolBar = UIToolbar()
        
        // расположим Тулбар над клавиатурой
        toolBar.sizeToFit()
        
        // добавим на ТулБар кнопку Готово
        // создадим кнопку
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveAction))
        
        if eventDateTextField.text == "" || eventTypeLabel.text == "тип события не выбран" || eventDescriptionTextView.text == "" {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
        
        // создадим "поле-пробел" что бы заполнить им пространство слева на ТулБаре
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // подключим кнопку к тулБару и настроим положение кнопки Готово на Тулбаре - справа
        toolBar.setItems([flexSpace, saveButton], animated: true)
        
        // подключаем созданный ТулБар к текстовому полю Даты
        eventDateTextField.inputAccessoryView = toolBar
        
        // подключаем созданный ТулБар к текстовому Вью заметок
        eventDescriptionTextView.inputAccessoryView = toolBar
    
    }
    
}


//// В это расширении добавим жест тапа (UITapGestureRecognizer) что бы при тапе по любой части tableView клавиатура скрывалась
//extension AddEventTableViewController {
//
//    // активируем режим отслеживания нажатия на tableView
//    func hideKeyboard() {
//        //
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
//        tableView.addGestureRecognizer(tap)
//    }
//
//    // скрываем клавиатуру с tableView и удаляем gestureRecognizers что бы tableView работал в обычном режиме
//    @objc func dismissKeyboard() {
//
//        // скрываем клавиатуру
//        tableView.endEditing(true)
//
//        // удаляем все экзкмпляры UITapGestureRecognizer которые привязаны к tableView
//        tableView.gestureRecognizers?.forEach(tableView.removeGestureRecognizer)
//
//    }
//}

    
extension AddEventTableViewController {
    
    func registerForKeyboardNotifications() {
        
        // ... будет реагировать на появление клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        
        // ... будет реагировать на перед началом изчезновения клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)

    }
    
    // удаление наблюдателей когда они уже не нужны
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        
    }
    
    
    
    
    // функция вычисляет размер сдвига и обращась к tableView задает растояние сдвига contentOffset
    @objc func kbWillShow(_ notification: Notification) {
        
        // запрашиваем параметры клавиатуры
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        currentKbHight = kbFrameSize.height
        
        // tableView.reloadData()
        
        // сдвигаем tableView на contentOffset
        // tableView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height - 80 )
        
        // в тот момент когда появилась клавиатура зарегистрируем нажатие UITapGestureRecognizer
        // hideKeyboard()
    }
    
    // функция обращась к tableView задает растояние сдвига contentOffset равное 0
    @objc func kbDidHide() {
        // tableView.contentOffset = CGPoint(x: 0, y: 0) // CGPoint.zero

    }
    
    
}
