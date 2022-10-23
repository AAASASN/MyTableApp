//
//  DetailedEventViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 19.09.2022.
//

import UIKit

class DetailedEventViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
     
//    // создадим нажатаие по экрану - активируем его (привязав к tableView) в тот момент когда будет появлятся клавиатура
//    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: DetailedEventViewController.self, action: #selector(DetailedEventViewController.dismissKeyboard))
    
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellForReturn = UITableViewCell()
        if indexPath.section == 0 {
            let standartCell = tableView.dequeueReusableCell(withIdentifier: "CellForEventHolder")!
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
        if indexPath.section == 1 {
            let customCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") as! OneEventSomeHolderTableViewCell_xib
            // насторойка ячейки
            customCell.configLabelsAndColorStile(eventID: self.eventHolderAndEventID.1)
            cellForReturn = customCell
        }
        
        //
        if indexPath.section == 2 {
            let cellForTextView = tableView.dequeueReusableCell(withIdentifier: "CellForTextView") as! TextViewTableViewCell
            
            // здесь передадим текст поздравления из Event из хранилища
            cellForTextView.textView.text = eventsStorage.getEventFromStorageByEventID(eventID: eventHolderAndEventID.1).congratulation
            // передадим в ячейку с TextView ID события
            cellForTextView.eventHolderAndEventID = eventHolderAndEventID
            
            // передаю экземпляр самого контроллера DetailedEventViewController чтобы потом из ячейки сдигать его
            // tableView для отображения клавиатуры
            cellForTextView.detailedEventViewController = self
            // присваиваем экземпляр для возврата
            cellForReturn = cellForTextView
        }
        
        if indexPath.section == 3 {
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: "AddEventButtonAsTableViewCellID") as! AddEventButtonAsTableViewCell
            // насторойка ячейки
            cellForReturn = buttonCell
        }
        return cellForReturn
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { return 60 }
        if indexPath.section == 1 { return 200 }
        if indexPath.section == 2 {
            let cellDinamicHeigth = view.frame.height - 470
            return cellDinamicHeigth
        }
        return 60
    }
    
    
    // MARK: - вариант реализации перехода на экран AddEventHolderViewController при помощи didSelectRowAt
    // при нажатии на первую ячейку/секцию будет совершен переход на контороллер AddEventHolderViewController
    // и в дальнейшем он будет использоваться для просмотра событий юбиляра и редактирования его свойств(характеристик)
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.gestureRecognizers?.forEach(tableView.removeGestureRecognizer)
        if indexPath.section == 0 && indexPath.row == 0 {
            // получаем вью контроллер, в который происходит переход
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let aboutEventHolderController = storyboard.instantiateViewController(withIdentifier: "AddEventHolderViewControllerID") as! AddEventHolderViewController

            // настраиваем aboutEventHolderController перед вызовом - передадим экземпляр EventHolder и заполняем текстовые поля
            aboutEventHolderController.prepareForReqestFromDetailedEventViewController(someEventHolderID: eventHolderAndEventID.0)

            // переходим к следующему экрану
            self.navigationController?.pushViewController(aboutEventHolderController, animated: true)
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
