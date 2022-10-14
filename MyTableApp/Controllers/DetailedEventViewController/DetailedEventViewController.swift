//
//  DetailedEventViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 19.09.2022.
//

import UIKit

class DetailedEventViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
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

        //tableView.contentOffset = 
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
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellForReturn = UITableViewCell()
        
        if indexPath.section == 0 {
            let standartCell = tableView.dequeueReusableCell(withIdentifier: "CellForEventHolder")!
        
            var content = standartCell.defaultContentConfiguration()

            // Configure content.
            content.image = UIImage(systemName: "star")
            if eventHolderAndEventID != nil {
                
                content.text = (eventsStorage.getEventHolderFromStorageByEventHolderID(eventHolderID: eventHolderAndEventID.0).eventHolderFirstName) + " " +
                (eventsStorage.getEventHolderFromStorageByEventHolderID(eventHolderID: eventHolderAndEventID.0).eventHolderLastName)
                content.secondaryText = (eventsStorage.getEventHolderFromStorageByEventHolderID(eventHolderID: eventHolderAndEventID.0).eventHolderStatus.rawValue)
            }
            // Customize appearance.
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
        
        /////////
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
        return cellForReturn
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { return 80 }
        if indexPath.section == 1 { return 200 }
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            // получаем вью контроллер, в который происходит переход
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let aboutEventHolderController = storyboard.instantiateViewController(withIdentifier: "AddEventHolderViewControllerID") as! AddEventHolderViewController
            
            // настраиваем aboutEventHolderController перед вызовом - передадим экземпляр EventHolder и заполняем текстовые поля
            aboutEventHolderController.prepareForReqestFromDetailedEventViewController(someEventHolderID: eventHolderAndEventID.0)
            
            // переходим к следующему экрану
            self.navigationController?.pushViewController(aboutEventHolderController, animated: true)        }
    }
}

//
extension DetailedEventViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let cellForTextView = tableView.dequeueReusableCell(withIdentifier: "CellForTextView") as! TextViewTableViewCell

        
        let cellForTextView = tableView.dequeueReusableCell(withIdentifier: "CellForTextView") as! TextViewTableViewCell
        cellForTextView.textView.endEditing(true)
        //self.textView.endEditing(true)
    }
    
}
