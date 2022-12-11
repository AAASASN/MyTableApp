//
//  EventStorage.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 08.07.2022.
//

import UIKit
import Foundation
import Contacts
import CoreData

// класс как хранилище массива [EventHolder]
class EventHolderArrayAsClass: Codable {
    var eventHolderArray = [EventHolder]()
}

protocol EventStorageProtocol {
    
    var eventHolderArrayAsClass: EventHolderArrayAsClass { get set }
    var eventHolderArrayGotFromContacts: [EventHolder] { get set }
    
    func getEventHolderArrayFromPhoneContacts()
    func getUpdatedDataToEventStorage()
    func addEventHolderToEventSrorage(newEventHolder: EventHolder)
    func getEventHolderAndEventArray() -> [(EventHolder, EventProtocol)]
    func removeEventOfSomeEventHolderFromSomeEventHolderAndEventSrorage(eventHolder: EventHolder, event: EventProtocol)
    func getEventHolderArrayFromEventStorage() -> [EventHolder]
    func addEventToExistedHolder(addingEvent event: Event, existedHolder: EventHolder)
    func addChangesOfEventHolderToEventStorage(changedEventHolder: EventHolder)
    func changeIsActualStatusForCurrentEvent(event: EventProtocol)
    func getEventHolderFromStorageByEventHolderID(eventHolderID: String) -> EventHolder
    func getEventFromStorageByEventID(eventID: String) -> Event
    func changeCongratulationInEvent(eventID: String, congratulationText: String)
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
    
    
    // временное хранилище для контактов выгруженых из телефонной книги Смартфона
    var eventHolderArrayGotFromContacts = [EventHolder]()
    
    
    // MARK: - методы доступные из вне
    
    // обновляем(актуализируем) экземпляр EventStorage - eventHolderArrayAsClass загружаем из userDefaults
    func getUpdatedDataToEventStorage(){
        getDataFromUserDefaultsToEventHolderArrayAsClass()
    }
    
    // добавляем элемент EventHolder в массив свойства eventHolderArrayAsClass.eventHolderArray
    func addEventHolderToEventSrorage(newEventHolder: EventHolder) {
        // перед добавлением проверим есть ли уже в хранилище EventHolder с таким же id
        var idCount = 0
        for someEventHolder in eventHolderArrayAsClass.eventHolderArray {
            if someEventHolder.eventHolderID == newEventHolder.eventHolderID {
                idCount += 1
            }
        }
        // если нет то добавляем
        if idCount == 0 {
            // добавляем EventHolder в массив eventHolderArrayAsClass.eventHolderArray
            eventHolderArrayAsClass.eventHolderArray.append(newEventHolder)
        }
        // обновляем состояние userDefaults с учетом нового элемента
        saveDataFromEventHolderArrayAsClassToUserDefaults()
        getDataFromUserDefaultsToEventHolderArrayAsClass()
        
    }
    
    // внесение изменений в EventHolder принятого в функцию
    func addChangesOfEventHolderToEventStorage(changedEventHolder: EventHolder) {
        // создаем временный массив в который переложим всех EventHolder кроме того который пришел в качестве аргумента в функцию
        var tempEventHolderArray: [EventHolder] = []
        // проходим по массиву EventHolder в хранилище
        for index in 0..<eventHolderArrayAsClass.eventHolderArray.count {
            // если ID EventHolder-a для принятого в функцию равен ID EventHolder-а в хранилище
            if changedEventHolder.eventHolderID != eventHolderArrayAsClass.eventHolderArray[index].eventHolderID {
                // добавляем этого EventHolder-a во временный массив
                tempEventHolderArray.append(eventHolderArrayAsClass.eventHolderArray[index])
            }
        }
        // теперь добавим во временный массив EventHolder-а который пришел в качестве аргумента в функцию
        tempEventHolderArray.append(changedEventHolder)
        // теперь пересохраняем массив EventHolder-ов в хранилище
        eventHolderArrayAsClass.eventHolderArray = tempEventHolderArray
        // и после этого обновляем состояние userDefaults с учетом нового элемента
        saveDataFromEventHolderArrayAsClassToUserDefaults()
        getDataFromUserDefaultsToEventHolderArrayAsClass()
    }
    
    // изменение текста поздравления в событии с определенным EventID
    func changeCongratulationInEvent(eventID: String, congratulationText: String ) {
        // проходим по массиву EventHolder в хранилище
        for eventHolder in eventHolderArrayAsClass.eventHolderArray {
            for event in eventHolder.events {
                if event.eventID == eventID {
                    event.congratulation = congratulationText
                    saveDataFromEventHolderArrayAsClassToUserDefaults()
                    getDataFromUserDefaultsToEventHolderArrayAsClass()
                }
            }
        }
    }
    
    // удаление EventHolder из хранилища
    func removeEventOfSomeEventHolderFromSomeEventHolderAndEventSrorage(eventHolder: EventHolder, event: EventProtocol) {
        // индекс для понимания остались ли у EventHolder события в массиве
        var indexForRemove: Int!
        
        // проходим по массиву EventHolder в хранилище
        for index in 0..<eventHolderArrayAsClass.eventHolderArray.count {
            // если ID EventHolder-a для принятого в функцию равен ID EventHolder-а в хранилище
            if eventHolder.eventHolderID == eventHolderArrayAsClass.eventHolderArray[index].eventHolderID {
                // и если в хранилище пользоапеля больше чем одно событие
                if eventHolderArrayAsClass.eventHolderArray[index].events.count > 1 {
                    // то мы перезаписываем все события из массива событий EventHolder в новый массив исключив из него событие пришедшее на удаление в функцию
                    var newEventArray = [Event]()
                    for indexInArray in 0..<eventHolderArrayAsClass.eventHolderArray[index].events.count {
                        if eventHolderArrayAsClass.eventHolderArray[index].events[indexInArray].eventID != event.eventID {
                            newEventArray.append(eventHolderArrayAsClass.eventHolderArray[index].events[indexInArray])
                        }
                    }
                    // и присваеваем EventHolder новый массив событий
                    eventHolderArrayAsClass.eventHolderArray[index].events = newEventArray
                } else {
                    // если же в хранилище пользоапеля только одно событие ставим в indexForRemove присваеваем ему индекс EventHolder-а в массиве хранилища
                    indexForRemove = index
                }
            }
        }
        // проверякм indexForRemove - если он не равен nil значит нужно удалить EventHolder-а из массиве хранилища
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
    
    // добавляем дополнительное событие к уже существующему eventHolder
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
    
    
    //эта функция будет менять значение isAcrual на противоположное в событии принятом в качестве аргумента
    func changeIsActualStatusForCurrentEvent(event: EventProtocol) {
        for eventHolder in eventHolderArrayAsClass.eventHolderArray {
            for targetEvent in eventHolder.events {
                if targetEvent.eventID == event.eventID {
                    targetEvent.isActual.toggle()
                    saveDataFromEventHolderArrayAsClassToUserDefaults()
                    getDataFromUserDefaultsToEventHolderArrayAsClass()
                }
            }
        }
    }
    
    // метод находит возвращает из хранилища экземрляр Event по его eventID
    func getEventFromStorageByEventID(eventID: String) -> Event {
        var eventForReturn: Event!
        for someEventHolder in eventHolderArrayAsClass.eventHolderArray {
            for someEvent in someEventHolder.events {
                if someEvent.eventID == eventID {
                    eventForReturn = someEvent
                }
            }
        }
        
        return eventForReturn
    }
    
    
    // метод находит возвращает из хранилища экземрляр EventHolder по его eventHolderID
    func getEventHolderFromStorageByEventHolderID(eventHolderID: String) -> EventHolder {
        getDataFromUserDefaultsToEventHolderArrayAsClass()
        var eventHolderForReturn: EventHolder!
        for someEventHolder in eventHolderArrayAsClass.eventHolderArray {
            if someEventHolder.eventHolderID == eventHolderID {
                eventHolderForReturn = someEventHolder
            }
        }
        return eventHolderForReturn
    }
    
    // MARK: - приватные методы
    
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
        } else { return }
        
        // иначе вызовем функцию getEventHolderArrayFromPhoneContacts() которая выгрузит из телефонной книги айфона контакты и вернет массив EventHolder
        
        //            //             иначе присвоим eventHolderArrayAsClass.eventHolderArray выдуманый  массив [EventHolder]
        //            //             или пустой массив
        //
        //            let date_1 = "25.06.1984 23:59:59"
        //            let date_2 = "05.06.2000 23:59:59"
        //            let date_3 = "02.11.1998 23:59:59"
        //
        //            let date_25 = "31.12.2004 23:59:59"
        //            let date_26 = "05.08.2019 23:59:59"
        //            let date_27 = "17.04.2021 23:59:59"
        //
        //            let dateFormatter = DateFormatter()
        //            dateFormatter.dateFormat = "dd.MM.yy HH:mm:ss"
        //
        //            let someEventHolderArray = [EventHolder(eventHolderFirstName: "Вася",
        //                                                    eventHolderLastName: "Васин",
        //                                                    eventHolderBirthdayDate: CustomDate(date: dateFormatter.date(from: date_1) ?? Date()),
        //                                                    eventHolderPhoneNumber : "+79051234567",
        //                                                    eventHolderSex: .male,
        //                                                    eventHolderStatus: .bestFriend,
        //                                                    events: [Event(eventDate: CustomDate(date: dateFormatter.date(from: date_1)!), eventType: .birthday,        eventDiscription: "описание", isActual: true),
        //                                                             Event(eventDate: CustomDate(date: dateFormatter.date(from: date_2)!), eventType: .birthOfChildren, eventDiscription: "описание", isActual: true),
        //                                                             Event(eventDate: CustomDate(date: dateFormatter.date(from: date_3)!), eventType: .wedding,         eventDiscription: "описание", isActual: true)]
        //                                                   ),
        //
        //                                        EventHolder(eventHolderFirstName: "Алла",
        //                                                    eventHolderLastName: "Пугачева",
        //                                                    eventHolderBirthdayDate: CustomDate(date: dateFormatter.date(from: date_25)!),
        //                                                    eventHolderPhoneNumber : "+79051234567",
        //                                                    eventHolderSex: .female,
        //                                                    eventHolderStatus: .none,
        //                                                    events: [Event(eventDate: CustomDate(date: dateFormatter.date(from: date_26)!), eventType: .wedding,         eventDiscription: "описание", isActual: true),
        //                                                             Event(eventDate: CustomDate(date: dateFormatter.date(from: date_27)!), eventType: .birthOfChildren, eventDiscription: "описание", isActual: true),
        //                                                             Event(eventDate: CustomDate(date: dateFormatter.date(from: date_25)!), eventType: .birthday,        eventDiscription: "описание", isActual: true)]
        //                                                   )]
        
        //            eventHolderArrayAsClass.eventHolderArray = getEventHolderArrayFromPhoneContacts()
        //        }
    }
    
    
    // MARK: - РАБОТА С КОНТАКТАМИ ТЕЛЕФОННОЙ КНИГИ
    // функция получения контактов из памяти телефона
    func getEventHolderArrayFromPhoneContacts() {
        print("начало работы функции getEventHolderArrayFromPhoneContacts()")
        
        var eventHolderArrayForReturn: [EventHolder] = []
        
        // получаем доступ к хранилищу контактов в телефоне
        let contactStore = CNContactStore()
        
        // создаем массив для хранения контактов которые выгрузим из хранилища contactStore
        var contacts = [CNContact]()
        
        // Проверка доступа
        
        // создадим Объект типа CNEntityType (это энум), который описывает то к чему пользователь
        // будет получать доступ, в общем-то это значение перечисления  - это всегда - .contacts
        let dataType = CNEntityType.contacts
        
        //  проверим получен ли доступ к контантам телефона - получаем энум со статусом - есть доступ, нет доступа и еще несколько статусов
        let authorizationStatus = CNContactStore.authorizationStatus(for: dataType)
        
        switch authorizationStatus {
        case .authorized:
            loadContacts()
        case .denied, .notDetermined:
            // запрашиваем разрешение если оно еще не запрашивалось или предыдущий запрос был отклонен
            contactStore.requestAccess(for: .contacts) { access, accessError in
                if access {
                    loadContacts()
                } else {
                    print("Право доступа к контактам не предоставлено")
                }
            }
        default:
            print("Нет прав доступа к контактам")
        }
        
        
        // функция которая получает контакты из телефонной книги
        func loadContacts() {
            print("начало работы функции loadContacts()")
            // если доступ есть то пробуем получить из CNContactStore контакты при помощи метода .enumerateContacts(with: usingBlock:)
            
            // для этого нужно передать в метод запрос в виде экземпляра класса CNContactFetchRequest в котором будeт указан формат данных
            // для получения, поскольку нам не всегда нужны все данные хранящиеся в конкретном контакте
            // и замыкание (CNContact, UnsafeMutablePointer<ObjCBool>) -> Void , которое уже и наполнит массив contacts контактами
            
            // создадим массив ключей которые будут соответствовать конткретным полям данных в запрашиваемом контакте
            let keyToFetch = [CNContactIdentifierKey as CNKeyDescriptor,
                              CNContactFamilyNameKey as CNKeyDescriptor,
                              
                              CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                              CNContactImageDataKey as CNKeyDescriptor,
                              CNContactBirthdayKey as CNKeyDescriptor,
                              CNContactPhoneNumbersKey as CNKeyDescriptor]
            
            // экземпляр CNContactFetchRequest проинициализируем массивом экземпляров CNKeyDescriptor - keyToFetch
            let request = CNContactFetchRequest(keysToFetch: keyToFetch)
            
            // поскольку метод .enumerateContacts(with: usingBlock:) может выбросить ошибку (исключение) нужно поместить его в блок do-catch
            do {
                try contactStore.enumerateContacts(with: request) { cnContact, error in
                    
                    // проверим пришедший в замыкание cnContact на то соответствуют ли его поля ключу нашего запроса
                    // скорее всего ID в нем есть
                    // if cnContact.isKeyAvailable(CNContactIdentifierKey) {
                    // помещаем полученные контакты в массив контакты
                    contacts.append(cnContact)
                    //}
                }
            } catch {
                print("Произошла ошибка при попытке получить данные контактв из телефонной книги")
            }
            
            print("удалось выгрузить \(contacts.count) контактов")
            
            // далее распарсим contacts в [EventHolder]
            
            for someContact in contacts {
                var events: [Event] = []
                // если из контактов в качестве birthday придет нил то присвоим дату 01.01.01  (ничего умнее не придумал)
                let someEvent = Event(eventDate: CustomDate(date: Calendar.current.date(from: someContact.birthday ?? DateComponents()) ?? CustomDate.getDefaultDate().date),
                                      eventType: .birthday,
                                      eventDiscription: "",
                                      isActual: true,
                                      eventID: "EventID_" + someContact.identifier)
                events.append(someEvent)
                
                if !someContact.givenName.isEmpty && someContact.phoneNumbers.count > 0  {
                    
                    print("---------------------------------------------------------")
                    print("identifier : " + someContact.identifier)
                    print("givenName : " + someContact.givenName)
                    print("familyName : " + someContact.familyName)
                    print("phoneNumbers : " + String(someContact.phoneNumbers.count))
                    print("---------------------------------------------------------")
                    
                    eventHolderArrayForReturn.append(EventHolder(eventHolderFirstName: someContact.givenName,
                                                                 eventHolderLastName: someContact.familyName,
                                                                 eventHolderBirthdayDate: CustomDate(date: Calendar.current.date(from: someContact.birthday ?? DateComponents()) ?? CustomDate.getDefaultDate().date),
                                                                 eventHolderPhoneNumber: someContact.phoneNumbers.description , //
                                                                 eventHolderSex: .none,
                                                                 eventHolderStatus: .none,
                                                                 events: events,
                                                                 eventHolderID: someContact.identifier))
                    
                }
            }
            
        }
        
        print(eventHolderArrayForReturn.count)
        
        // присваиваем полученный массив во временное хранилище
        eventHolderArrayGotFromContacts =  eventHolderArrayForReturn
        
        // а затем сразу сохраняем его в UserDefaults
        saveDataFromEventHolderArrayAsClassToUserDefaults()
    }
    
    
//    func getArrayOfContactsFromCNContact(from: CNContact) -> [String] {
//        var arrayForReturn = [String]()
//        //let description = from.phoneNumbers.description
//
//        for char in from.phoneNumbers[0]. {
//            if let someString = char["Mobile"]  {
//                arrayForReturn.append(someString)
//                print(someString)
//            }
//        }
//        return arrayForReturn
//    }
    
    
}



