//
//  AddSexTableViewCell.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 19.07.2022.
//

import UIKit

class AddSexTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var sexField: UITextField!
    
    var pickerView = UIPickerView()
    
    let pickerViewData = ["Мужской", "Женский"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sexField.text = pickerViewData[row]
    }
    
//    func rowSize(forComponent component: Int) -> CGSize {
//        let size = CGSize(width: 100, height: 100)
//        return size
//    }
    
    // Устанавливаем высоту строки
   /*
                Высота по умолчанию 32, если не задано, метод UIPickerViewDelegate
   */
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {

       return 40
   }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sexField.inputView = pickerView
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        
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
        sexField.inputAccessoryView = toolBar
       
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
