//
//  CustomDate.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 02.08.2022.
//

import Foundation

// Класс CustomDate это класс для описания дат включайющий в себя
// свойство типа Date и вычисляемое свойство dateIntDayAndMonth : Int
// в котором будет храниться число дней до дня рождения с учетом текещей даты

class CustomDate {
    /// собственно дата
    var date : Date
    
    /// вычисляемое свойство которое будет хранить дату в текстовом формате
    var dateAsString : String {
        func getDateAsStringFromDate() -> String {
            // создадим экземпляр типа DateFormatter
            let formater = DateFormatter()
            // настроим локализацию - для отображения на русском языке
            formater.locale = Locale(identifier: "ru_RU")
            // настроим вид отображения даты в текстовом виде
            formater.dateFormat = "d MMMM yyyy"
            // передадим в текстовое поле dateField строку обработанное форматером принятое от datePicker
            return formater.string(from: date)
        }
        return getDateAsStringFromDate()
    }
    
    ///  вычисляемое свойство для отслеживания количества дней до события
    ///  вычисляется из date и текущей даты на устройстве

    var daysCountBeforeEvent : Int {
        
        /// несколько функций для повторяющегося кода
        /// суть кода: в зависимости от того наступит событие до конца текущего года
        /// или уже в следущем году, вычисляет количество дней между текущей датой
        /// и ближайшем событием юбиляра, отбрасывая год события и назначая ему новый гол
        /// в дату
        func funcForNextYear() {
            var currentDateComponents_1 = currentDateComponents
            currentDateComponents_1.year! += 1
            dateComponents.year = currentDateComponents_1.year
            funcForCurrentYearOrNextYearContent()
        }
        
        func funcForCurrentYear() {
            dateComponents.year = currentDateComponents.year
            funcForCurrentYearOrNextYearContent()
        }
        
        func funcForCurrentYearOrNextYearContent() {
            let newDate_1 = calendar.date(from: dateComponents)
            newDate = newDate_1!
            if let dateDiffDay = Calendar.current.dateComponents([.day], from: currentDate, to: newDate).day {
                daysCountBeforeEventForReturn  = dateDiffDay
            } else {
                daysCountBeforeEventForReturn  = 0
            }
        }
        
        /// подготовка  при помощи колендаря  компонентов даты с которыми будем производить вычисления
        let calendar = Calendar.current
        var daysCountBeforeEventForReturn  = 0
        var dateComponents = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"

        /// создаем экземпляр даты со значением текущей даты и времени
        let currentDate = Date()
        /// вытаскиваеи из currentDate интересующие компоненты
        let currentDateComponents = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: currentDate)
        
        /// новая дата это та в которую будет преобразована дата события заменой года события
        /// на текущий или следущий за текущим год
        var newDate = Date()
        
        /// выбор условия для замеы года события на текущий или следущий за текущим год
        if dateComponents.month! > currentDateComponents.month! {funcForCurrentYear()}
        if dateComponents.month! < currentDateComponents.month! {funcForNextYear()}
        if dateComponents.month! == currentDateComponents.month! {
            if dateComponents.day! > currentDateComponents.day! {funcForCurrentYear()}
            if dateComponents.day! < currentDateComponents.day! {funcForNextYear()}
            if dateComponents.day! == currentDateComponents.day! {
                if dateComponents.hour! > currentDateComponents.hour! {funcForCurrentYear()}
                if dateComponents.hour! < currentDateComponents.hour! {funcForNextYear()}
                if dateComponents.hour! == currentDateComponents.hour! {
                    if dateComponents.minute! > currentDateComponents.minute! {funcForCurrentYear()}
                    if dateComponents.minute! < currentDateComponents.minute! {funcForNextYear()}
                    if dateComponents.minute! == currentDateComponents.minute! {
                        if dateComponents.second! > currentDateComponents.second! {funcForCurrentYear()}
                        if dateComponents.second! < currentDateComponents.second! {funcForNextYear()}
                        if dateComponents.second! == currentDateComponents.second! {daysCountBeforeEventForReturn  = 0}
                    }
                }
            }
        }
        return daysCountBeforeEventForReturn
    }

    init(date: Date) {
        self.date = date
    }

}


