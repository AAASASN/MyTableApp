//
//  EventStorage.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 08.07.2022.
//

import Foundation

// класс как хранилище массива [EventHolder]
class EventHolderArrayAsClass: Codable {
    var eventHolderArray = [EventHolder]()
}

protocol EventStorageProtocol {
    
    var eventHolderArrayAsClass: EventHolderArrayAsClass { get set }

    
    func getUpdatedDataToEventStorage()
    func addEventHolderToEventSrorage(newEventHolder: EventHolder)
    func getEventHolderAndEventArray() -> [(EventHolder, EventProtocol)]
    func removeEventHolderFromEventSrorage(removedEventHolder: EventHolder, removedEvent: EventProtocol)
    func getEventHolderArrayFromEventStorage() -> [EventHolder]
    func addEventToExistedHolder(addingEvent event: Event, existedHolder: EventHolder)

}

class EventStorage: EventStorageProtocol {

    // enum для хранения ключей для работы с userDefaults
    enum enumForStoreKeys: String {
        case UDKey
    }
    

    // его экземпляр
    var eventHolderArrayAsClass = EventHolderArrayAsClass()

    // сам userDefaults
    fileprivate var userDefaults = UserDefaults.standard
    
    
    // MARK: - методы доступные из вне
    
    // обновляем(актуализируем) экземпляр EventStorage - eventHolderArrayAsClass загружаем из userDefaults
    func getUpdatedDataToEventStorage(){
        getDataFromUserDefaultsToEventHolderArrayAsClass()
    }
    
    // добавляем элемент EventHolder в массив свойства eventHolderArrayAsClass.eventHolderArray
    func addEventHolderToEventSrorage(newEventHolder: EventHolder) {
        
        // выгружаем из UserDefaults данные в eventHolderArrayAsClass
        // getDataFromUserDefaultsToEventHolderArrayAsClass()
        
        // добавляем EventHolder в массив eventHolderArrayAsClass.eventHolderArray
        eventHolderArrayAsClass.eventHolderArray.append(newEventHolder)
        // и обновляем состояние userDefaults с учетом нового элемента
        saveDataFromEventHolderArrayAsClassToUserDefaults()
        getDataFromUserDefaultsToEventHolderArrayAsClass()

    }
    
    // удаление EventHolder из хранилища
    func removeEventHolderFromEventSrorage(removedEventHolder: EventHolder, removedEvent: EventProtocol) {
        
//        // выгружаем из UserDefaults данные в eventHolderArrayAsClass
//        getDataFromUserDefaultsToEventHolderArrayAsClass()
        var indexForRemove: Int!
        for index in 0..<eventHolderArrayAsClass.eventHolderArray.count {
            if removedEventHolder.eventHolderFirstName == eventHolderArrayAsClass.eventHolderArray[index].eventHolderFirstName && removedEventHolder.eventHolderLastName == eventHolderArrayAsClass.eventHolderArray[index].eventHolderLastName {
                if eventHolderArrayAsClass.eventHolderArray[index].events.count > 1 {
                    var newEventArray = [Event]()
                    for indexInArray in 0..<eventHolderArrayAsClass.eventHolderArray[index].events.count {
                        if eventHolderArrayAsClass.eventHolderArray[index].events[indexInArray].eventType != removedEvent.eventType && eventHolderArrayAsClass.eventHolderArray[index].events[indexInArray].eventDate.date != removedEvent.eventDate.date {
                            newEventArray.append(eventHolderArrayAsClass.eventHolderArray[index].events[indexInArray])
                            //eventHolderArrayAsClass.eventHolderArray[index].events.remove(at: indexInArray)
                        }
                    }
                    eventHolderArrayAsClass.eventHolderArray[index].events = newEventArray
                } else {
                    indexForRemove = index
                }
            }
        }
        if indexForRemove != nil { eventHolderArrayAsClass.eventHolderArray.remove(at: indexForRemove) }
        // сохраняем новое состояние eventHolderArrayAsClass в UserDefaults
        saveDataFromEventHolderArrayAsClassToUserDefaults()
        getDataFromUserDefaultsToEventHolderArrayAsClass()
    }
    
    // просто получить массив [EventHolder]
    func getEventHolderArrayFromEventStorage() -> [EventHolder] {
//        // сначала обновим хранилище
//        getDataFromUserDefaultsToEventHolderArrayAsClass()
        return eventHolderArrayAsClass.eventHolderArray
    }
    
    // функция которая будет возвращать массив кортежей  [(EventHolder, Event)] и сортировать по приближению даты Event
    // используется по сути только на стартовом экране
    func getEventHolderAndEventArray() -> [(EventHolder, EventProtocol)] {
        //предварительно обновим состояние eventHolderArrayAsClass из userDefaults
        getDataFromUserDefaultsToEventHolderArrayAsClass()
        var tupleArrayForReturn :  [(EventHolder, EventProtocol)] = []
        for item in eventHolderArrayAsClass.eventHolderArray {
            for i in item.events{
                tupleArrayForReturn.append((item, i))
            }
        }
        // сортировка по дате
        let sortedTuplesArrayForReturn = tupleArrayForReturn.sorted(by: { $0.1.eventDate.daysCountBeforeEvent  <= $1.1.eventDate.daysCountBeforeEvent})
        return sortedTuplesArrayForReturn
    }
    
    // добавляем дополнительное событие к уже существующему ventHolder
    func addEventToExistedHolder(addingEvent event: Event, existedHolder: EventHolder) {
//        //предварительно обновим состояние eventHolderArrayAsClass из userDefaults
//        getDataFromUserDefaultsToEventHolderArrayAsClass()
        for index in 0..<eventHolderArrayAsClass.eventHolderArray.count {
            if eventHolderArrayAsClass.eventHolderArray[index].eventHolderFirstName == existedHolder.eventHolderFirstName && eventHolderArrayAsClass.eventHolderArray[index].eventHolderLastName == existedHolder.eventHolderLastName {
                eventHolderArrayAsClass.eventHolderArray[index].events.append(event)
                break
            }
        }
        saveDataFromEventHolderArrayAsClassToUserDefaults()
    }
    
    // MARK: - приватные методы
//    // обновляем userDefaults до состояния eventHolderArrayAsClass
//    func setUserDefaultsFromEventHolderArrayAsClass(){
//        <#function body#>
//    }
    
    // сохраняем состояние eventHolderArrayAsClass в userDefaults
    private func saveDataFromEventHolderArrayAsClassToUserDefaults() {
        // создаем экземпляр JSONEncoder()
        let encoder = JSONEncoder()
        // и с его помощью преобразуем данные для сохранения в userDefaults к типу Data
        let eventHolderArrayAsClassAsData = try? encoder.encode(eventHolderArrayAsClass)
        // засовываем эти данные в userDefaults по ключу
        userDefaults.set(eventHolderArrayAsClassAsData, forKey: enumForStoreKeys.UDKey.rawValue)
    }
    
    // эта функция присваивает eventHolderArrayAsClass данные вытащеные из userDefaults
    private func getDataFromUserDefaultsToEventHolderArrayAsClass() {
        // вытащим из userDefaults объект типа Data и распарсим его до типа EventHolderArrayAsClass при помощи возможностей JSONDecoder()
        if let dataFromUserDefaults = userDefaults.object(forKey: enumForStoreKeys.UDKey.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let newEventHolderArrayAsClass = try? decoder.decode(EventHolderArrayAsClass.self, from: dataFromUserDefaults){
                // присвоим это значение self.eventHolderArrayAsClass
                eventHolderArrayAsClass = newEventHolderArrayAsClass
            }
        } else {
//             иначе присвоим eventHolderArrayAsClass.eventHolderArray выдуманый  массив [EventHolder]
//             или пустой массив
            
            let date_1 = "25.06.1984 23:59:59"
            let date_2 = "05.06.2000 23:59:59"
            let date_3 = "02.11.1998 23:59:59"

            let date_25 = "31.12.2004 23:59:59"
            let date_26 = "05.08.2019 23:59:59"
            let date_27 = "17.04.2021 23:59:59"

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
            eventHolderArrayAsClass.eventHolderArray = someEventHolderArray
        }
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
    

    
}
