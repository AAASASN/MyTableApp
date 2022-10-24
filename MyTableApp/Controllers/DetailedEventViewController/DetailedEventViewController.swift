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
        
        // настройка большого navigationItem.title в DetailedEventViewController
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        eventsStorage.getUpdatedDataToEventStorage()
        // tableView.isScrollEnabled = true
        tableView.reloadData()
    }
    
}

extension DetailedEventViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    // вызов ячеек
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellForReturn = UITableViewCell()
        // вызов стандартной ячейки
        if indexPath.section == 0 {
            let standartCell = tableView.dequeueReusableCell(withIdentifier: "CellForEventHolder")!
            // настройка через стандарнтый конфигуратор UIListContentConfiguration
            var content = standartCell.defaultContentConfiguration()
            content.image = UIImage(systemName: "star")
            if eventHolderAndEventID != nil {
                content.text = (eventsStorage.getEventHolderFromStorageByEventHolderID(eventHolderID: eventHolderAndEventID.0).eventHolderFirstName) + " " +
                (eventsStorage.getEventHolderFromStorageByEventHolderID(eventHolderID: eventHolderAndEventID.0).eventHolderLastName)
                content.secondaryText = (eventsStorage.getEventHolderFromStorageByEventHolderID(eventHolderID: eventHolderAndEventID.0).eventHolderStatus.rawValue)
            }
            content.imageProperties.tintColor = .purple
            standartCell.contentConfiguration = content
            cellForReturn = standartCell
        }
        // создание ячейки на основе _xib
        if indexPath.section == 1 {
            let customCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") as! OneEventSomeHolderTableViewCell_xib
            // насторойка ячейки встроенным методом
            customCell.configLabelsAndColorStile(eventID: self.eventHolderAndEventID.1)
            cellForReturn = customCell
        }
        
        // создание ячейки для редактиапвание текста поздравления
        if indexPath.section == 2 {
            let cellForTextView = tableView.dequeueReusableCell(withIdentifier: "CellForTextView") as! TextViewTableViewCell
            
            // здесь передадим текст поздравления из Event из хранилища
            cellForTextView.textView.text = eventsStorage.getEventFromStorageByEventID(eventID: eventHolderAndEventID.1).congratulation
            // передадим в ячейку с TextView ID события
            cellForTextView.eventHolderAndEventID = eventHolderAndEventID
            // передаю экземпляр самого контроллера DetailedEventViewController чтобы потом из ячейки сдигать его
            // tableView для отображения клавиатуры
            // (ВОЗМОЖНО ЭТО НЕ БЕЗОПАСНО - РЕШЕНИЕ ТРЕБУЕТ ПРОВЕРКИ)
            cellForTextView.detailedEventViewController = self
            // присваиваем экземпляр для возврата
            cellForReturn = cellForTextView
        }
        
        // ячейка-кнопка для перехода на экран просмотра текста поздравления
        if indexPath.section == 3 {
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: "AddEventButtonAsTableViewCellID") as! AddEventButtonAsTableViewCell
            // насторойка ячейки
            cellForReturn = buttonCell
        }
        return cellForReturn
    }
    
    // настройка высоты ячеек
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { return CGFloat(texViewCellHeight0) }
        if indexPath.section == 1 { return CGFloat(texViewCellHeight1) }
        if indexPath.section == 2 {
            let cellDinamicHeigth = view.frame.height - CGFloat(texViewCellHeight2)
            return cellDinamicHeigth
        }
        return CGFloat(texViewCellHeight3)
    }
    
    
    // MARK: - вариант реализации перехода на экран AddEventHolderViewController при помощи didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // удаляем всех наблюдателей у tableView
        tableView.gestureRecognizers?.forEach(tableView.removeGestureRecognizer)
        // при нажатии на первую ячейку/секцию будет совершен переход на контороллер AddEventHolderViewController
        // и в дальнейшем он будет использоваться для просмотра событий юбиляра и редактирования его свойств(характеристик)
        if indexPath.section == 0 && indexPath.row == 0 {
            // получаем вью контроллер, в который происходит переход
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let aboutEventHolderController = storyboard.instantiateViewController(withIdentifier: "AddEventHolderViewControllerID") as! AddEventHolderViewController
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

// это расширение возволяет скрыть клавиатуру при косании вне TextView или TextField.
// Данное решение подходит для случая когда TextView или TextField расположены внутри ScrollView
extension DetailedEventViewController {
    
    // активируем режим отслеживания нажатия на tableView
    func hideKeyboard() {
        //
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailedEventViewController.dismissKeyboard))
        tableView.addGestureRecognizer(tap)
    }

    // скрываем клавиатуру с tableView и удаляем gestureRecognizers что бы tableView работал в обычном режиме
    @objc func dismissKeyboard() {
        // удаляем все экзкмпляры UITapGestureRecognizer которые привязаны к tableView
        tableView.gestureRecognizers?.forEach(tableView.removeGestureRecognizer)
        // скрываем клавиатуру
        tableView.endEditing(true)
    }
    
}


//extension DetailedEventViewController {
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//}
