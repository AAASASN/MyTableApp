//
//  DetailedEventViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 19.09.2022.
//

import UIKit

class DetailedEventViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // переменные для работы с шириной ячеек
     var texViewCellHeight0 = 60
     var texViewCellHeight1 = 200
     var texViewCellHeight2 = 470
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
        
        // настройка большого navigationItem.title в DetailedEventViewController
        // self.navigationItem.largeTitleDisplayMode = .never
        
        
        // вызываем метод который будет регистрировать наблюдателей
        registerForKeyboardNotifications()
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        eventsStorage.getUpdatedDataToEventStorage()
        // tableView.isScrollEnabled = true
        tableView.reloadData()
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
            let standartCell = tableView.dequeueReusableCell(withIdentifier: "CellForEventHolder")!
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
        
        // Ячейка второй сектции
        // создание ячейки на основе _xib
        if indexPath.section == 1 {
            let customCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") as! OneEventSomeHolderTableViewCell_xib
            // насторойка ячейки встроенным методом
            customCell.configLabelsAndColorStile(eventID: self.eventHolderAndEventID.1)
            cellForReturn = customCell
        }
        
        // Ячейка третьей секции
        // создание ячейки для редактиапвание текста поздравления
        if indexPath.section == 2 {
            let cellForTextView = tableView.dequeueReusableCell(withIdentifier: "CellForTextView") as! TextViewTableViewCell
            
            // здесь передадим текст поздравления из Event из хранилища
            cellForTextView.textView.text = eventsStorage.getEventFromStorageByEventID(eventID: eventHolderAndEventID.1).congratulation
            // передадим в ячейку с TextView ID события
            cellForTextView.eventHolderAndEventID = eventHolderAndEventID
            
            // ??????????????
            cellForTextView.detailedEventViewController = self
            
            
            // присваиваем экземпляр для возврата
            cellForReturn = cellForTextView
        }
        
        // Ячейка третьей секции
        // ячейка-кнопка для перехода на экран просмотра текста поздравления
        if indexPath.section == 3 {
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: "AddEventButtonAsTableViewCellID") as! AddEventButtonAsTableViewCell
            // насторойка ячейки
            cellForReturn = buttonCell
        }
        return cellForReturn
    }
    
    // MARK: - heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { return CGFloat(texViewCellHeight0) }
        if indexPath.section == 1 { return CGFloat(texViewCellHeight1) }
        
        // Высота ячейки с UITextView подстраивается под высоту экрана
        if indexPath.section == 2 {
            let cellDinamicHeigth = view.frame.height - CGFloat(texViewCellHeight2)
            return cellDinamicHeigth
        }
        return CGFloat(texViewCellHeight3)
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
            // получаем вью контроллер, в который происходит переход
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let congratulationViewController = storyboard.instantiateViewController(withIdentifier: "CongratulationViewControllerID") as! CongratulationViewController
            // передаем текст поздравления
            congratulationViewController.congratulationText = eventsStorage.getEventFromStorageByEventID(eventID: eventHolderAndEventID.1).congratulation
            // переходим к следующему экрану
            self.navigationController?.pushViewController(congratulationViewController, animated: true)
        }
        
    }
}

// MARK: - hide keyboard
// это расширение возволяет скрыть клавиатуру при косании вне TextView или TextField.
// Данное решение подходит для случая когда TextView или TextField расположены внутри ScrollView
extension DetailedEventViewController {
    
    // активируем режим отслеживания нажатия на tableView
    func hideKeyboard() {
        //
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tableView.addGestureRecognizer(tap)
    }

    // скрываем клавиатуру с tableView и удаляем gestureRecognizers что бы tableView работал в обычном режиме
    @objc func dismissKeyboard() {
          
        // скрываем клавиатуру
        tableView.endEditing(true)
        
        // удаляем все экзкмпляры UITapGestureRecognizer которые привязаны к tableView
        // tableView.gestureRecognizers?.forEach(tableView.removeGestureRecognizer)
        
    }
    
    // MARK: - код позволяет сдвигать экран DetailedEventViewController вверх и обратно вниз при появлении и проподании клавиатуры
    
    // этот метод будет вызван в viewDidLoad, он регистрирует наблюдателей которые...
    func registerForKeyboardNotifications() {
        
        // ... будет реагировать на появление клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // ... будет реагировать на перед началом изчезновения клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // ... будет реагировать после изчезновения клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
    }
    
    // удаление наблюдателей когда они уже не нужны
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // функция вычисляет размер сдвига и обращась к tableView задает растояние сдвига contentOffset
    @objc func kbWillShow(_ notification: Notification) {
        
        // запрашиваем параметры клавиатуры
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        // сдвигаем tableView на contentOffset
        tableView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height - 80 )
        
        // в тот момент когда появилась клавиатура зарегистрируем нажатие UITapGestureRecognizer
        hideKeyboard()
    }
    
    // функция обращась к tableView задает растояние сдвига contentOffset равное 0
    @objc func kbWillHide() {
        tableView.contentOffset = CGPoint(x: 0, y: 0) // CGPoint.zero

    }
    
    @objc func kbDidHide() {
         // удаляем все экзкмпляры UITapGestureRecognizer которые привязаны к tableView
         tableView.gestureRecognizers?.forEach(tableView.removeGestureRecognizer)
    }
    
}


