//
//  DetailedEventViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 19.09.2022.
//

import UIKit

class DetailedEventViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    // свойство для загрузки в него хранилища с данными
    var eventsStorage : EventStorageProtocol = EventStorage()
    
    // var eventHolderAndEvent : (EventHolder, EventProtocol)!
    var eventHolderAndEventID: (String, String)!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
//        let cellForTextView = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! TextViewTableViewCell
//        cellForTextView.textView.delegate = self
        
        
        
//        но пока при этом решенеии не работает didSelectRowAt
//        self.hideKeyboard()
        
        // зарегистрируем Nib ячейки
        let cellNib = UINib(nibName: "OneEventSomeHolderTableViewCell_xib", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "reuseIdentifier")
        
        eventsStorage.getUpdatedDataToEventStorage()
        tableView.reloadData()

        
        //
        self.navigationItem.title = eventsStorage.getEventHolderFromStorageByEventHolderID(eventHolderID: eventHolderAndEventID.0).eventHolderFirstName + " " + eventsStorage.getEventHolderFromStorageByEventHolderID(eventHolderID: eventHolderAndEventID.0).eventHolderLastName
        
        // настройка большого navigationItem.title в DetailedEventViewController
        self.navigationItem.largeTitleDisplayMode = .always
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        eventsStorage.getUpdatedDataToEventStorage()
        
        tableView.reloadData()
        
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
            
            // пока здесь укажу какой-то текст, в дальнейшем сюда будет подтягиваться текст поздравления из Event
            cellForTextView.textView.text = "Здесь будет текст поздравления У вас будет 5 дней на выполнение практической работы. Отсчёт времени начнётся после нажатия кнопки. В этот момент вы увидите описание задания. Приступайте к практике, когда будете готовы. До нажатия кнопки дедлайн не сгорит. Если возникнут сложности, задайте вопрос в разделе “Вопросы по заданию” и получите ответ от экспертов и одногруппников. У вас будет 5 дней на выполнение практической работы. Отсчёт времени начнётся после нажатия кнопки. В этот момент вы увидите описание задания. Приступайте к практике, когда будете готовы. До нажатия кнопки дедлайн не сгорит. Если возникнут сложности, задайте вопрос в разделе “Вопросы по заданию” и получите ответ от экспертов и одногруппников."
            
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
        if indexPath.section == 2 { return 250 }
        return 60
    }
    
    // при нажатии на первую ячейку/секцию будет совершен переход на контороллер AddEventHolderViewController
    // и в дальнейшем он будет использоваться для просмотра событий юбиляра и редактирования его свойств(характеристик)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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


// но пока при этом решенеии не работает didSelectRowAt

// это расширение возволяет скрыть клавиатуру при косании вне TextView или TextField.
// Данное решение подходит для случая когда TextView или TextField расположены внутри ScrollView

//extension DetailedEventViewController {
//
//    func hideKeyboard() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
//            target: self,
//            action: #selector(DetailedEventViewController.dismissKeyboard))
//
//        view.addGestureRecognizer(tap)
//    }
//
//    // есть несколько способов скрыть клавиатуру - разные варианты в закоментированом коде
//    @objc func dismissKeyboard() {
//
//        tableView.endEditing(true)
//
////          let cellForTextView = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! TextViewTableViewCell
////
////
//////        cellForTextView.doneAction()
////          cellForTextView.textView.endEditing(true)
//    }
//
//}

