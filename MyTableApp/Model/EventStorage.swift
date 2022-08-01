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
        
        let someEventHolderArray = [EventHolder(eventHolderFirstName: "Вася",
                                                eventHolderLastName: "Васин",
                                                eventHolderBirthdayDate: "25.04.1984",
                                                eventHolderPhoneNumber : "+79051234567",
                                                sex: true,
                                                eventHolderStatus: .bestFriend,
                                                events: [Event(eventDate: "25.04.1984", eventType: .birthday,        eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: "17.03.2019", eventType: .birthOfChildren, eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: "01.12.1990", eventType: .wedding,         eventDiscription: "описание", isActual: true)]
                                               ),
                                    
                                    EventHolder(eventHolderFirstName: "Владимир",
                                                eventHolderLastName: "Васин",
                                                eventHolderBirthdayDate: "01.12.1990",
                                                eventHolderPhoneNumber : "+79051234567",
                                                sex: true,
                                                eventHolderStatus: .schoolFriend,
                                                events: [Event(eventDate: "01.12.1990", eventType: .wedding,         eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: "17.03.2019", eventType: .birthOfChildren, eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: "01.12.1990", eventType: .birthday,        eventDiscription: "описание", isActual: true)]
                                                ),
                                    
                                    EventHolder(eventHolderFirstName: "Стас",
                                                eventHolderLastName: "Владимиров",
                                                eventHolderBirthdayDate: "03.09.2006",
                                                eventHolderPhoneNumber : "+79051234567",
                                                sex: true,
                                                eventHolderStatus: .schoolFriend,
                                                events: [Event(eventDate: "01.12.1990", eventType: .wedding,         eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: "17.03.2019", eventType: .birthOfChildren, eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: "03.09.2006", eventType: .birthday,        eventDiscription: "описание", isActual: true)]
                                                ),
                                    
                                    EventHolder(eventHolderFirstName: "Сергей",
                                                eventHolderLastName: "Стасов",
                                                eventHolderBirthdayDate: "11.07.1964",
                                                eventHolderPhoneNumber : "+79051234567",
                                                sex: true,
                                                eventHolderStatus: .colleague,
                                                events: [Event(eventDate: "01.12.1990", eventType: .wedding,         eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: "17.03.2019", eventType: .birthOfChildren, eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: "11.07.1964", eventType: .birthday,        eventDiscription: "описание", isActual: true)]
                                                ),
                                    
                                    EventHolder(eventHolderFirstName: "Роман",
                                                eventHolderLastName: "Сергеев",
                                                eventHolderBirthdayDate: "20.08.1978",
                                                eventHolderPhoneNumber : "+79051234567",
                                                sex: true,
                                                eventHolderStatus: .colleague,
                                                events: [Event(eventDate: "01.12.1990", eventType: .wedding,         eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: "17.03.2019", eventType: .birthOfChildren, eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: "20.08.1978", eventType: .birthday,        eventDiscription: "описание", isActual: true)]
                                                
                                               ),
                                    
                                    EventHolder(eventHolderFirstName: "Андрей",
                                                eventHolderLastName: "Романов",
                                                eventHolderBirthdayDate: "06.10.2000",
                                                eventHolderPhoneNumber : "+79051234567",
                                                sex: true,
                                                eventHolderStatus: .colleague,
                                                events: [Event(eventDate: "01.12.1990", eventType: .wedding,         eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: "17.03.2019", eventType: .birthOfChildren, eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: "06.10.2000", eventType: .birthday,        eventDiscription: "описание", isActual: true)]
                                                ),
                                    
                                    EventHolder(eventHolderFirstName: "Екатерина",
                                                eventHolderLastName: "Андреева",
                                                eventHolderBirthdayDate: "07.12.2014",
                                                eventHolderPhoneNumber : "+79051234567",
                                                sex: false,
                                                eventHolderStatus: .someFriend,
                                                events: [Event(eventDate: "01.12.1990", eventType: .wedding,         eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: "17.03.2019", eventType: .birthOfChildren, eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: "07.12.2014", eventType: .birthday,        eventDiscription: "описание", isActual: true)]
                                                ),
                                    
                                    EventHolder(eventHolderFirstName: "София",
                                                eventHolderLastName: "Старовойтова",
                                                eventHolderBirthdayDate: "31.12.2004",
                                                eventHolderPhoneNumber : "+79051234567",
                                                sex: false,
                                                eventHolderStatus: .someFriend,
                                                events: [Event(eventDate: "01.12.1990", eventType: .wedding,         eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: "17.03.2019", eventType: .birthOfChildren, eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: "31.12.2004", eventType: .birthday,        eventDiscription: "описание", isActual: true)]
                                                
                                                ),
                                    
                                    EventHolder(eventHolderFirstName: "Алла",
                                                eventHolderLastName: "Пугачева",
                                                eventHolderBirthdayDate: "19.01.2011",
                                                eventHolderPhoneNumber : "+79051234567",
                                                sex: false,
                                                eventHolderStatus: .none,
                                                events: [Event(eventDate: "01.12.1990", eventType: .wedding,         eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: "17.03.2019", eventType: .birthOfChildren, eventDiscription: "описание", isActual: true),
                                                         Event(eventDate: "19.01.2011", eventType: .birthday,        eventDiscription: "описание", isActual: true)]
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
        
        var tupleForReturn :  [(EventHolderProtocol, EventProtocol)] = []
        for item in eventHolderArray {
            for i in item.events{
                tupleForReturn.append((item, i))
            }
        }
        
        // сортировка
        // var sortedTupleForReturn = tupleForReturn.sorted(by: {_, })
        return tupleForReturn
    }
}
