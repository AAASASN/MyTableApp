//
//  AddDataTableViewCell.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 19.07.2022.
//

import UIKit

class AddDateTableViewCell: UITableViewCell {

    @IBOutlet weak var dateField: UITextField!
    
    let datePicker = UIDatePicker()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // назначаем datePicker способом ввода для редактирования dateField через свойство .inputView
        dateField.inputView = datePicker
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        
        // установим текущую дату максимальным значеним на datePicker
        datePicker.maximumDate = .now
        
        // настроим формат отображения даты в соответствии с языковыми настройками айфона пользователя
        let localeID = Locale.preferredLanguages.first
        datePicker.locale = Locale(identifier: localeID!)
        
        // создадим Тулбар, позже расположим его над ДейтПикером
        let toolBar = UIToolbar()
        
        //
        toolBar.sizeToFit()
         
        // добавим на ТулБар кнопку Готово
        // создадим кнопку
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        
        // создадим "поле-пробел" что бы заполнить им пространство слева на ТулБаре
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // подключим кнопку к тулБару и настроим положение кнопки Готово на Тулбаре - справа
        toolBar.setItems([flexSpace, doneButton], animated: true)
        
        
        // подключаем созданный ТулБар к текстовому полю ( ТулБар привязывается не к datePicker а к dateField и отображается совместно с ним )
        dateField.inputAccessoryView = toolBar
        
        // чтобы значения в dateField менялись при прокручивании колесика datePicker "повесим событие" на datePicker
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
//
//        // это решение позволяет скрыть datePicker при тапе на
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureDone))
//        forEndEditingDelegate.funcForEndEditingDelegate()
//        //self.contentView.addGestureRecognizer(tapGesture)
        
    }

    // при нажатии на кнопку Готово скрывает datePicker
    @objc func doneAction (){
        
        contentView.endEditing(true)
    }
    
    // при изменении значений на datePicker будет обновлять dateField
    @objc func dateChanged (){
        getDateFromPicker()
    }
    
    // при тапе на свободное место на view  скрывает datePicker
    @objc func tapGestureDone (){
        getDateFromPicker()
        contentView.endEditing(true)

    }
    
    // Создадим функцию которая будет возвращать дату в нужном формате и передавать ее в текстовом виде в текстовое поле
    func getDateFromPicker() {
        // создадим экземпляр типа DateFormatter
        let formater = DateFormatter()
        // настроим вариант отображения даты в текстовом виде
        formater.dateFormat = "dd.MM.yy"
        // передадим в текстовое поле dateField строку обработанное форматером принятое от datePicker
        dateField.text = formater.string(from: datePicker.date)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
