//
//  Event.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 08.07.2022.
//

import Foundation



enum EventHolderSex : String {
    case male = "Мужской"
    case female = "Женский"
    case third = "Третий пол"
    case none = "Пол не выбран"
}

enum EventHolderStatus : String {
    case schoolFriend  = "Школьный друг"
    case bestFriend = "Лучший друг"
    case someFriend = "Просто знакомый"
    case none = "Статус не определен"
    case colleague  = "Коллега"
}

enum EventType : String, CaseIterable {
    case birthday = "день рождения"
    case birthOfChildren = "день рождения ребенка"
    case wedding = "свадьба"
    case housewarming = "новоселье"
    case none  = "тип события не выбран"
    //case addEventButton = "addEventButton"
}

protocol EventProtocol {
    var eventDate : CustomDate { get set }
    var eventType : EventType { get set }
    var eventDiscription : String { get set }
    var isActual : Bool { get set }
}

class Event: EventProtocol {
    var eventDate : CustomDate
    var eventType : EventType
    var eventDiscription : String
    var isActual : Bool
    
    init(eventDate: CustomDate,  eventType: EventType, eventDiscription : String, isActual : Bool ) {
        self.eventDate = eventDate
        self.eventType = eventType
        self.eventDiscription = eventDiscription
        self.isActual = isActual
    }
}


