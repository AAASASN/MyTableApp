//
//  TextViewTableViewCell.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 14.10.2022.
//

import UIKit

class TextViewTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    
    // свойство для хранения экземпляра DetailedEventViewController что бы потом обращаться к нему при скрытии клавиатуры
    var detailedEventViewController: DetailedEventViewController!
    
    deinit {
        removeKeyboardNotifications()
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // настроим тулбар
        createAndAddingToolBarToKeyboard()
        //
        registerForKeyboardNotifications()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// расширение для работы с клавиатурой
extension TextViewTableViewCell {
    
    // Настроим ToolBar над клавиатурой и кнопку Готово после нажатия на которую клавиатура будет скрыватьс
    func createAndAddingToolBarToKeyboard() {
        // создадим Тулбар, позже расположим его над клавиатурой
        let toolBar = UIToolbar()
        //
        toolBar.sizeToFit()
        // добавим на ТулБар кнопку Готово
        // создадим кнопку
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(doneAction))
        
        // создадим "поле-пробел" что бы заполнить им пространство слева на ТулБаре
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // подключим кнопку к тулБару и настроим положение кнопки Готово на Тулбаре - справа
        toolBar.setItems([flexSpace, doneButton], animated: true)
        
        // подключаем созданный ТулБар ко всем текстовым полям
        textView.inputAccessoryView = toolBar
    }
    
    // при нажатии на кнопку Готово на тулбаре скрывает клавиатуру
    @objc func doneAction (){
        // при нажатии на кнопку Готово на тулбаре скрывает клавиатуру
        self.contentView.endEditing(true)
        
        detailedEventViewController.tableView.resignFirstResponder()
        
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        detailedEventViewController.tableView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height)
    }
    
    @objc func kbWillHide() {
        detailedEventViewController.tableView.contentOffset = CGPoint.zero
    }
    
    
}
