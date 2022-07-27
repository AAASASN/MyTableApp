//
//  AddSecondNameTableViewCell.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 19.07.2022.
//

import UIKit

class AddSecondNameTableViewCell: UITableViewCell {

    @IBOutlet weak var secondNameField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()

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
        secondNameField.inputAccessoryView = toolBar
       
        
    }
    
    // при нажатии на кнопку Готово скрывает клавиатуру
    @objc func doneAction (){
        contentView.endEditing(true)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
