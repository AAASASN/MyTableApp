//
//  PhoneNumberTextFieldTableViewCell.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 12.09.2022.
//

import UIKit

class PhoneNumberTextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    var datePicker = UIDatePicker()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //
    
        // настроим тулбар
        createAndAddingToolBarToKeyboard()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    

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
        textField.inputAccessoryView = toolBar
    }
    
    // при нажатии на кнопку Готово на тулбаре скрывает клавиатуру
    @objc func doneAction (){
        self.contentView.endEditing(true)
    }

    //настройка DatePicker, вызывается во viewDidLoad
    func datePickerSwttings() {
        // и назначим datePicker способом ввода в текстовое поле
        textField.inputView = datePicker
        // назначим стиль - колесики
        datePicker.preferredDatePickerStyle = .wheels
        // установим первое значение на текущую дату
        datePicker.datePickerMode = .date
        // установим текущую дату максимальным значеним на datePicker
        if #available(iOS 15, *) {
            datePicker.maximumDate = .now
        } else {
            // Fallback on earlier versions
        }
        // чтобы значения в textField менялись при прокручивании колесика datePicker "повесим событие" на datePicker
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        // настроим формат отображения даты в соответствии с языковыми настройками айфона пользователя
        let localeID = Locale.preferredLanguages.first
        datePicker.locale = Locale(identifier: localeID!)
    }
    
    // при изменении значений на datePicker будет обновлять textField
    @objc func dateChanged (){
        getDateFromPicker()
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
        textField.text = formater.string(from: datePicker.date)
    }

}
