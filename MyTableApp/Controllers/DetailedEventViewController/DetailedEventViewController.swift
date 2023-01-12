//
//  DetailedEventViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 19.09.2022.
//

import UIKit

class DetailedEventViewController: UIViewController {

    var scrollView: UIScrollView!
    var contentView: UIView!
    var tableView: UITableView!
    var tap: UITapGestureRecognizer!

    // переменные для работы с шириной ячеек
     var texViewCellHeight0 = 60
     var texViewCellHeight1 = 200
     // var texViewCellHeight2 = 470
     var texViewCellHeight3 = 60
    
    // свойство для загрузки в него хранилища с данными
    var eventsStorage : EventStorageProtocol = EventStorage()
    
    // var eventHolderAndEvent : (EventHolder, EventProtocol)!
    var eventHolderAndEventID: (String, String)!

    // пока не понятно отрабатывает ли
    deinit {
        removeKeyboardNotifications()
    }
    
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        scrollViewSettings()
        tableViewSettings()
        
        tableView.delegate = self
        tableView.dataSource = self

        
        
        // зарегистрируем Nib ячейки
        let cellNib = UINib(nibName: "OneEventSomeHolderTableViewCell_xib", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "reuseIdentifier")
        
        eventsStorage.getUpdatedDataToEventStorage()
        tableView.reloadData()

        
        // настройка navigationItem.title в DetailedEventViewController
        
        self.navigationItem.title = eventsStorage.getEventHolderFromStorageByEventHolderID(eventHolderID: eventHolderAndEventID.0).eventHolderFirstName + " " + eventsStorage.getEventHolderFromStorageByEventHolderID(eventHolderID: eventHolderAndEventID.0).eventHolderLastName
        
        self.navigationItem.title = eventsStorage.getEventFromStorageByEventID(eventID: eventHolderAndEventID.1).eventType.rawValue
        
        // вызываем метод который будет регистрировать наблюдателей
        registerForKeyboardNotifications()
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        registerForKeyboardNotifications()

        eventsStorage.getUpdatedDataToEventStorage()
        // tableView.isScrollEnabled = true
        tableView.reloadData()
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardNotifications()
    }
    
}


extension DetailedEventViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    // MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    // MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellForReturn = UITableViewCell()
        
        // Ячейка первой секции
        // Здесь можно наблюдать пример работы со страндартной ячейкой
        if indexPath.section == 0 {
                        
            let standartCell = UITableViewCell(style: .default, reuseIdentifier: nil)

            // настройка через стандарнтый конфигуратор UIListContentConfiguration
            var content = standartCell.defaultContentConfiguration()
            content.image = UIImage(systemName: "person.circle")
            if eventHolderAndEventID != nil {
                content.text = (eventsStorage.getEventHolderFromStorageByEventHolderID(eventHolderID: eventHolderAndEventID.0).eventHolderFirstName) + " " +
                (eventsStorage.getEventHolderFromStorageByEventHolderID(eventHolderID: eventHolderAndEventID.0).eventHolderLastName)
                content.secondaryText = (eventsStorage.getEventHolderFromStorageByEventHolderID(eventHolderID: eventHolderAndEventID.0).eventHolderStatus.rawValue)
            }
            content.imageProperties.tintColor = .purple
            standartCell.contentConfiguration = content
            cellForReturn = standartCell
        }
        
        // Ячейка второй сектции, создание ячейки на основе _xib
        if indexPath.section == 1 {
            
            let customCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") as! OneEventSomeHolderTableViewCell_xib
            
            // насторойка ячейки встроенным методом
            customCell.configLabelsAndColorStile(eventID: self.eventHolderAndEventID.1)
            cellForReturn = customCell
        }
        
        // Ячейка третьей секции
        // создание ячейки для редактиапвание текста поздравления
        if indexPath.section == 2 {
            
            let cellForTextView = TextViewTableViewCell(style: .default, reuseIdentifier: nil)

            // передадим текст поздравления из Event из хранилища
            cellForTextView.textView.text = eventsStorage.getEventFromStorageByEventID(eventID: eventHolderAndEventID.1).congratulation
            
            cellForTextView.delegate = self
            
            // передадим в ячейку с TextView ID события
            cellForTextView.eventHolderAndEventID = eventHolderAndEventID
            
            // присваиваем экземпляр для возврата
            cellForReturn = cellForTextView
        }
        
        // Ячейка третьей секции
        // ячейка-кнопка для перехода на экран просмотра текста поздравления
        if indexPath.section == 3 {
            let buttonCell =  AddEventButtonAsTableViewCell(style: .default, reuseIdentifier: nil)
            // насторойка ячейки
            buttonCell.buttonLabel.text = "Поздравить"
            cellForReturn = buttonCell
        }
        return cellForReturn
    }
    
    // MARK: - heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var valueForReturn: CGFloat = 0
        
        if indexPath.section == 0 { valueForReturn = CGFloat(texViewCellHeight0) }
        if indexPath.section == 1 { valueForReturn = CGFloat(texViewCellHeight1) }
        
        // Высота ячейки с UITextView подстраивается под высоту экрана
        if indexPath.section == 2 {
//            valueForReturn = view.frame.height - self.view.safeAreaInsets.bottom - self.view.safeAreaInsets.top - CGFloat(texViewCellHeight2)
            valueForReturn = CGFloat(Int(contentView.frame.height) - texViewCellHeight0 - texViewCellHeight1 - texViewCellHeight3 - 170)

        }
        
        if indexPath.section == 3 { valueForReturn = CGFloat(texViewCellHeight3) }

        return valueForReturn
    }
    
    
    // MARK: - didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // при нажатии на первую ячейку/секцию будет совершен переход на контороллер AddEventHolderViewController
        // и в дальнейшем он будет использоваться для просмотра событий юбиляра и редактирования его свойств(характеристик)
        if indexPath.section == 0 && indexPath.row == 0 {
            
            let aboutEventHolderController = AddEventHolderViewController()
            
            // настраиваем aboutEventHolderController перед вызовом - передадим экземпляр EventHolder и заполняем текстовые поля
            aboutEventHolderController.prepareForReqestFromDetailedEventViewController(someEventHolderID: eventHolderAndEventID.0)
            // переходим к следующему экрану
            self.navigationController?.pushViewController(aboutEventHolderController, animated: true)
            
        }
        
        // переход на экран просмотра текста поздравления
        if indexPath.section == 3 && indexPath.row == 0 {
            
            // обновляем состояние хранилища переде передачей из него текста поздравления
            eventsStorage.getUpdatedDataToEventStorage()
                        
            let congratulationViewController = CongratulationViewController()
            
//            // получаем вью контроллер, в который происходит переход
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let congratulationViewController = storyboard.instantiateViewController(withIdentifier: "CongratulationViewControllerID") as! CongratulationViewController
            
            // передаем текст поздравления
            congratulationViewController.congratulationText = eventsStorage.getEventFromStorageByEventID(eventID: eventHolderAndEventID.1).congratulation
            
            // переходим к следующему экрану
            self.navigationController?.pushViewController(congratulationViewController, animated: true)
        }
        
    }
}

// MARK: - tableViewSettings
extension DetailedEventViewController {
    
    func tableViewSettings()  {
        tableView = {
            let tableView = UITableView(frame: .zero, style: .insetGrouped)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(tableView)
            NSLayoutConstraint.activate([
                                         tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
                                         tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                         tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                         tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
            return tableView
        }()
        tableView.isScrollEnabled = false
    }
}

// MARK: - scrollViewSettings
extension DetailedEventViewController {
    
    func scrollViewSettings() {
        
        scrollView = {
            let scrollView = UIScrollView(frame: .zero)
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(scrollView)
            NSLayoutConstraint.activate([scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                                         scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                                         scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                                         scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)])
            return scrollView
        }()
        
        // contentView
        contentView = {
            let contentView = UIView(frame: .zero)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(contentView)
            NSLayoutConstraint.activate([
                contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
                contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
            ])
            return contentView
        }()
    }
}


// MARK: - Keyboard
// это расширение возволяет скрыть клавиатуру при косании вне TextView или TextField.
// Данное решение подходит для случая когда TextView или TextField расположены внутри ScrollView
extension DetailedEventViewController {

    // активируем режим отслеживания нажатия на tableView
    func registerTapGestureRecognizerForHideKeyboard() {
        tableView.addGestureRecognizer(tap)
        viewWillLayoutSubviews()
    }
    
    // деактивируем режим отслеживания нажатия на tableView
    func removeTapGestureRecognizerForHideKeyboard() {
        tableView.removeGestureRecognizer(tap)
        viewWillLayoutSubviews()
    }

    // скрываем клавиатуру с scrollView и удаляем gestureRecognizers что бы scrollView работал в обычном режиме
    @objc func dismissKeyboard() {
        // скрываем клавиатуру
        tableView.endEditing(true)
        removeTapGestureRecognizerForHideKeyboard()
    }


    // этот метод будет вызван в viewDidLoad, он регистрирует наблюдателей которые...
    func registerForKeyboardNotifications() {

        // ... будет реагировать на появление клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        // ... будет реагировать на начало изчезновения клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    // удаление наблюдателей когда они уже не нужны
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // функция вычисляет размер сдвига и обращась к scrollView задает растояние сдвига contentOffset
    @objc func kbWillShow(_ notification: Notification) {
                
        // запрашиваем параметры клавиатуры
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        // сдвигаем tableView на contentOffset минус некоторое значение
        let yValue = kbFrameSize.height - view.safeAreaInsets.bottom - 100
        scrollView.contentOffset = CGPoint(x: 0, y: yValue)

        // в тот момент когда появилась клавиатура зарегистрируем нажатие UITapGestureRecognizer
        registerTapGestureRecognizerForHideKeyboard()

    }

    // функция обращась к tableView задает растояние сдвига contentOffset равное 0
    @objc func kbWillHide() {
        
        // сдвигаем tableView на contentOffset
        scrollView.contentOffset = CGPoint(x: 0, y: 0)

    }

}
