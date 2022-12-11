//
//  TextViewTableViewCell.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 14.10.2022.
//

import UIKit

class TextViewTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    // свойство для хранения экземпляра DetailedEventViewController что бы потом при появлении или скрытии клавиатуры обращаться к нему для сдвига его tableView
    weak var detailedEventViewController: DetailedEventViewController!
        
    // var eventHolderAndEvent : (EventHolder, EventProtocol)!
    var eventHolderAndEventID: (String, String)!
    
    // свойство для загрузки в него хранилища с данными
    var eventsStorage : EventStorageProtocol = EventStorage()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // назначим ячейку делегатом textView после этого будут работать методы
        textView.delegate = self
        
        // настроим тулбар
        createAndAddingToolBarToKeyboard()
        
        // ? не понятно будет ли корректно работать
        eventsStorage.getUpdatedDataToEventStorage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

// добавим метод textViewDidBeginEditing
extension TextViewTableViewCell {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Начало, когда вы начинаете редактирование
        print("сработал метод textViewDidBeginEditing")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("сработал метод textViewDidEndEditing")
    }

}

// расширение для работы с клавиатурой
extension TextViewTableViewCell {
    
    // Настроим ToolBar над клавиатурой и кнопку Готово после нажатия на которую клавиатура будет скрываться
    func createAndAddingToolBarToKeyboard() {
        // создадим Тулбар, позже расположим его над клавиатурой
        let toolBar = UIToolbar()
        //
        toolBar.sizeToFit()
        
        // добавим на ТулБар кнопку Готово
        // создадим кнопку
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(doneAction))
        
        // создадим на Тулбар кнопку Сохранить которая будет сохранять текст поздравления из
        // в TextView в свойство (?)  в Event и сохранять в хранилище
        let saveTextButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveTextAction))
        
        // создадим "поле-пробел" что бы заполнить им пространство слева на ТулБаре
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // подключим все кнопки к тулБару и настроим положение на Тулбаре кнопок Сохранить - слева и Готово - справа
        toolBar.setItems([saveTextButton, flexSpace, doneButton], animated: true)
        
        // подключаем созданный ТулБар к TextView
        textView.inputAccessoryView = toolBar
    }
    
    // при нажатии на кнопку Готово на тулбаре скрывает клавиатуру
    @objc func doneAction(){
        // при нажатии на кнопку Готово на тулбаре скрывается клавиатура
        self.contentView.endEditing(true)
    }
    
    // при нажатии на кнопку Сохранить текст поздравления будет сохраняться в хранилище
    @objc func saveTextAction(){
        
        // сохраняем текст поздравления в хранилище
        eventsStorage.changeCongratulationInEvent(eventID: eventHolderAndEventID.1, congratulationText: textView.text)
        // обновляем состояние хранилища
        eventsStorage.getUpdatedDataToEventStorage()

        // при нажатии на кнопку Сохранить на тулбаре скрывается клавиатура
        self.contentView.endEditing(true)
    }
    
}
