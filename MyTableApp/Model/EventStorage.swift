//
//  EventStorage.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 08.07.2022.
//

import Foundation

protocol EventStorageProtocol {
    var userDefaults : UserDefaults { get set }
    var eventHolderArray : [EventHolderProtocol] { get set }
    
    //func getDataFromUserDefaults() -> [EventProtocol]
    func getDataFromUserDefaults() -> [EventHolderProtocol]
    func getEventHolderAndEventArray() -> [(EventHolderProtocol, EventProtocol)]
    
    // func sortEventStorageByEventHolderStatus() -> [EventHolderStatus : [EventHolderProtocol]]
    func saveDataTouserDefaults(eventArray: [EventProtocol]) -> Void
}

class EventStorage: EventStorageProtocol {

    var eventHolderArray = [EventHolderProtocol]()
    
    var userDefaults = UserDefaults()
    
    func saveDataTouserDefaults(eventArray: [EventProtocol]) {
        userDefaults.set(eventArray, forKey: "keyForUD")
    }
//
//    // эта функция присваивает свойству eventArray тестовый массив событий(Event), в будующем массив будет вытаскиваться из userDefaults
//    func getDataFromUserDefaults() -> [EventProtocol] {
//        let someEventArray  = [ Event(eventHolder: "Вася",   eventDate: "25.04.1984", eventHolderStatus: .bestFriend, eventType: .wedding),
//                                Event(eventHolder: "Вова",   eventDate: "01.12.1990", eventHolderStatus: .someFriend, eventType: .wedding),
//                                Event(eventHolder: "Стас",   eventDate: "03.09.2006", eventHolderStatus: .someFriend, eventType: .wedding),
//                                Event(eventHolder: "Сергей", eventDate: "17.03.2019", eventHolderStatus: .colleague, eventType: .wedding),
//                                Event(eventHolder: "Рома",   eventDate: "11.07.1964", eventHolderStatus: .colleague, eventType: .wedding),
//                                Event(eventHolder: "Андрей", eventDate: "20.08.1978", eventHolderStatus: .colleague, eventType: .housewarming),
//                                Event(eventHolder: "Катя",   eventDate: "06.10.2000", eventHolderStatus: .schoolFriend, eventType: .housewarming),
//                                Event(eventHolder: "Гадя",   eventDate: "07.12.2014", eventHolderStatus: .schoolFriend, eventType: .housewarming),
//                                Event(eventHolder: "София",  eventDate: "31.12.2004", eventHolderStatus: .schoolFriend, eventType: .housewarming),
//                                Event(eventHolder: "Алла",   eventDate: "19.01.2011", eventHolderStatus: .schoolFriend, eventType: .birthday),
//                                Event(eventHolder: "Карл",   eventDate: "29.03.1989", eventHolderStatus: .none, eventType: .birthday),
//                                Event(eventHolder: "Наташа", eventDate: "05.11.2001", eventHolderStatus: .none, eventType: .birthday),
//                                Event(eventHolder: "Саша",   eventDate: "11.08.2014", eventHolderStatus: .none, eventType: .birthOfChildren),
//                                Event(eventHolder: "Слава",  eventDate: "21.05.2013", eventHolderStatus: .none, eventType: .birthOfChildren),
//                                Event(eventHolder: "Егор",   eventDate: "18.02.1995", eventHolderStatus: .none, eventType: .none) ]
//        return someEventArray
//    }
    
    
    // эта функция присваивает свойству eventArray тестовый массив событий(Event), в будующем массив будет вытаскиваться из userDefaults
    func getDataFromUserDefaults() -> [EventHolderProtocol] {
        
        let date_1 = "25.06.1984 23:59:59"
        let date_2 = "05.06.2000 23:59:59"
        let date_3 = "02.11.1998 23:59:59"

        let date_4 = "01.12.1990 23:59:59"
        let date_5 = "15.07.2011 23:59:59"
        let date_6 = "02.12.2013 23:59:59"

        let date_7 = "03.09.2006 23:59:59"
        let date_8 = "18.03.2020 23:59:59"
        let date_9 = "14.07.2021 23:59:59"

        let date_10 = "17.03.2019 23:59:59"
        let date_11 = "03.08.1981 23:59:59"
        let date_12 = "01.10.2013 23:59:59"

        let date_13 = "11.07.1964 23:59:59"
        let date_14 = "14.02.1999 23:59:59"
        let date_15 = "21.09.2009 23:59:59"

        let date_16 = "04.08.1978 23:59:59"
        let date_17 = "06.08.1984 23:59:59"
        let date_18 = "19.09.1980 23:59:59"

        let date_19 = "06.10.2000 23:59:59"
        let date_20 = "08.01.2010 23:59:59"
        let date_22 = "29.11.2019 23:59:59"

        let date_21 = "07.12.2014 23:59:59"
        let date_23 = "09.10.2020 23:59:59"
        let date_24 = "14.05.2019 23:59:59"

        let date_25 = "31.12.2004 23:59:59"
        let date_26 = "05.08.2019 23:59:59"
        let date_27 = "17.04.2021 23:59:59"

        
//         let date_1 = "02.08.22"
//         let date_2 = "05.06"
//         let date_3 = "02.11"
//         
//         let date_4 = "01.12"
//         let date_5 = "15.07"
//         let date_6 = "02.12"
//         
//         let date_7 = "03.09"
//         let date_8 = "25.06"
//         let date_9 = "25.06"
//         
//         let date_10 = "17.03"
//         let date_11 = "25.06"
//         let date_12 = "25.06"
//         
//         let date_13 = "11.07"
//         let date_14 = "25.06"
//         let date_15 = "25.06"
//         
//         let date_16 = "20.08"
//         let date_17 = "25.06"
//         let date_18 = "25.06"
//         
//         let date_19 = "06.10"
//         let date_20 = "25.06"
//         let date_22 = "25.06"
//         
//         let date_21 = "07.12"
//         let date_23 = "25.06"
//         let date_24 = "25.06"
//         
//         let date_25 = "31.12"
//         let date_26 = "25.06"
//         let date_27 = "25.06"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm:ss"
        
        let someEventHolderArray = [EventHolder(eventHolderFirstName: "Вася",
                                                eventHolderLastName: "Васин",
                                                eventHolderBirthdayDate: dateFormatter.date(from: date_1)!,
                                                eventHolderPhoneNumber : "+79051234567",
                                                sex: .male,
                                                eventHolderStatus: .bestFriend,
                                                events: [Event(eventDate: CustomDate(date: dateFormatter.date(from: date_1)!), eventType: .birthday,        eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: CustomDate(date: dateFormatter.date(from: date_2)!), eventType: .birthOfChildren, eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: CustomDate(date: dateFormatter.date(from: date_3)!), eventType: .wedding,         eventDiscription: "описание", isActual: true)]
                                               ),
                                    
                                    EventHolder(eventHolderFirstName: "Владимир",
                                                eventHolderLastName: "Васин",
                                                eventHolderBirthdayDate: dateFormatter.date(from: date_4)!,
                                                eventHolderPhoneNumber : "+79051234567",
                                                sex: .male,
                                                eventHolderStatus: .schoolFriend,
                                                events: [Event(eventDate: CustomDate(date: dateFormatter.date(from: date_5)!), eventType: .wedding,         eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: CustomDate(date: dateFormatter.date(from: date_6)!), eventType: .birthOfChildren, eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: CustomDate(date: dateFormatter.date(from: date_4)!), eventType: .birthday,        eventDiscription: "описание", isActual: true)]
                                                ),
                                    
                                    EventHolder(eventHolderFirstName: "Стас",
                                                eventHolderLastName: "Владимиров",
                                                eventHolderBirthdayDate: dateFormatter.date(from: date_7)!,
                                                eventHolderPhoneNumber : "+79051234567",
                                                sex: .male,
                                                eventHolderStatus: .schoolFriend,
                                                events: [Event(eventDate: CustomDate(date: dateFormatter.date(from: date_8)!), eventType: .wedding,         eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: CustomDate(date: dateFormatter.date(from: date_9)!), eventType: .birthOfChildren, eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: CustomDate(date: dateFormatter.date(from: date_7)!), eventType: .birthday,        eventDiscription: "описание", isActual: true)]
                                                ),
                                    
                                    EventHolder(eventHolderFirstName: "Сергей",
                                                eventHolderLastName: "Стасов",
                                                eventHolderBirthdayDate: dateFormatter.date(from: date_10)!,
                                                eventHolderPhoneNumber : "+79051234567",
                                                sex: .third,
                                                eventHolderStatus: .colleague,
                                                events: [Event(eventDate: CustomDate(date: dateFormatter.date(from: date_11)!), eventType: .wedding,         eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: CustomDate(date: dateFormatter.date(from: date_12)!), eventType: .birthOfChildren, eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: CustomDate(date: dateFormatter.date(from: date_10)!), eventType: .birthday,        eventDiscription: "описание", isActual: true)]
                                                ),
                                    
                                    EventHolder(eventHolderFirstName: "Роман",
                                                eventHolderLastName: "Сергеев",
                                                eventHolderBirthdayDate: dateFormatter.date(from: date_13)!,
                                                eventHolderPhoneNumber : "+79051234567",
                                                sex: .male,
                                                eventHolderStatus: .colleague,
                                                events: [Event(eventDate: CustomDate(date: dateFormatter.date(from: date_14)!), eventType: .wedding,         eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: CustomDate(date: dateFormatter.date(from: date_15)!), eventType: .birthOfChildren, eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: CustomDate(date: dateFormatter.date(from: date_13)!), eventType: .birthday,        eventDiscription: "описание", isActual: true)]
                                                
                                               ),
                                    
                                    EventHolder(eventHolderFirstName: "Андрей",
                                                eventHolderLastName: "Романов",
                                                eventHolderBirthdayDate: dateFormatter.date(from: date_16)!,
                                                eventHolderPhoneNumber : "+79051234567",
                                                sex: .male,
                                                eventHolderStatus: .colleague,
                                                events: [Event(eventDate: CustomDate(date: dateFormatter.date(from: date_17)!), eventType: .wedding,         eventDiscription: "описание",  isActual: true),
                                                         Event(eventDate: CustomDate(date: dateFormatter.date(from: date_18)!), eventType: .birthOfChildren, eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: CustomDate(date: dateFormatter.date(from: date_16)!), eventType: .birthday,        eventDiscription: "описание", isActual: true)]
                                                ),
                                    
                                    EventHolder(eventHolderFirstName: "Екатерина",
                                                eventHolderLastName: "Андреева",
                                                eventHolderBirthdayDate: dateFormatter.date(from: date_19)!,
                                                eventHolderPhoneNumber : "+79051234567",
                                                sex: .female,
                                                eventHolderStatus: .someFriend,
                                                events: [Event(eventDate: CustomDate(date: dateFormatter.date(from: date_20)!), eventType: .wedding,         eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: CustomDate(date: dateFormatter.date(from: date_21)!), eventType: .birthOfChildren, eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: CustomDate(date: dateFormatter.date(from: date_19)!), eventType: .birthday,        eventDiscription: "описание", isActual: true)]
                                                ),
                                    
                                    EventHolder(eventHolderFirstName: "София",
                                                eventHolderLastName: "Старовойтова",
                                                eventHolderBirthdayDate: dateFormatter.date(from: date_22)!,
                                                eventHolderPhoneNumber : "+79051234567",
                                                sex: .female,
                                                eventHolderStatus: .someFriend,
                                                events: [Event(eventDate: CustomDate(date: dateFormatter.date(from: date_23)!), eventType: .wedding,         eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: CustomDate(date: dateFormatter.date(from: date_24)!), eventType: .birthOfChildren, eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: CustomDate(date: dateFormatter.date(from: date_22)!), eventType: .birthday,        eventDiscription: "описание", isActual: true)]
                                                
                                                ),
                                    
                                    EventHolder(eventHolderFirstName: "Алла",
                                                eventHolderLastName: "Пугачева",
                                                eventHolderBirthdayDate: dateFormatter.date(from: date_25)!,
                                                eventHolderPhoneNumber : "+79051234567",
                                                sex: .female,
                                                eventHolderStatus: .none,
                                                events: [Event(eventDate: CustomDate(date: dateFormatter.date(from: date_26)!), eventType: .wedding,         eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: CustomDate(date: dateFormatter.date(from: date_27)!), eventType: .birthOfChildren, eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: CustomDate(date: dateFormatter.date(from: date_25)!), eventType: .birthday,        eventDiscription: "описание", isActual: true)]
                                                )]
         return someEventHolderArray
    }
    
//    // функция возвращает словарь dicForReturn ключами которого являются EventHolderStatus а значениями массив событий EventHolder
//    func sortEventStorageByEventHolderStatus() -> [EventHolderStatus : [EventHolderProtocol]] {
//        
//        // присвоим свойству eventHolderArray значения из UserDefaults
//        eventHolderArray = getDataFromUserDefaults()
//
//        // переменная для хранения возврощаемого значения
//        var dicForReturn = [EventHolderStatus : [EventHolderProtocol]]()
//        
//        // в переменной eventHolderStatusArray будем хранить просто список уникальных статусов типа EventHolderStatus  из массива eventHolderArray
//        var eventHolderStatusArray : [EventHolderStatus] = []
//        // сначало заполним eventHolderStatusArray значениями
//        for i in eventHolderArray {
//            if !eventHolderStatusArray.contains(i.eventHolderStatus) {
//                eventHolderStatusArray.append(i.eventHolderStatus)
//            }
//        }
//        
//        //теперь заполним словарь dicForReturn в качестве ключей будем использовать значения из EventHolderStatusArray а значениями будут массивы типа EventHolder содержащие этот статус
//        for i in eventHolderStatusArray {
//            var eventHolderArrayForSort = [EventHolderProtocol]()
//            for s in eventHolderArray {
//                if i == s.eventHolderStatus {
//                    eventHolderArrayForSort.append(s)
//                }
//            }
//            dicForReturn[i] = eventHolderArrayForSort
//        }
//        return dicForReturn
//    }
    
    // новая функция которая будет возвращать массив кортежей  [(EventHolder, Event)] и сортировать по приближению даты Event
    func getEventHolderAndEventArray() -> [(EventHolderProtocol, EventProtocol)] {
        
        // присвоим свойству eventHolderArray значения из UserDefaults
        eventHolderArray = getDataFromUserDefaults()
        
        var tupleArrayForReturn :  [(EventHolderProtocol, EventProtocol)] = []
        for item in eventHolderArray {
            for i in item.events{
                tupleArrayForReturn.append((item, i))
            }
        }
        
        // сортировка по дате
        let sortedTuplesArrayForReturn = tupleArrayForReturn.sorted(by: { $0.1.eventDate.daysCountBeforeEvent  <= $1.1.eventDate.daysCountBeforeEvent})
        return sortedTuplesArrayForReturn
    }
    
}
