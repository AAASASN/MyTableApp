//
//  Event.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 08.07.2022.
//

import Foundation

enum EventHolderSex : String {
    case male = "мужской"
    case female = "женский"
    case third = "третий пол"
    case none = "пол не выбран"
}

enum EventHolderStatus : String {
    case schoolFriend  = "Школьный друг"
    case bestFriend = "Лучший друг"
    case someFriend = "Просто знакомый"
    case none = "Статус не определен"
    case colleague  = "Коллега"
}

enum EventType : String {
    case birthday = "день рождения"
    case birthOfChildren = "день рождения ребенка"
    case wedding = "годовщина свадьбы"
    case housewarming = "новоселье"
    case none  = "none"
}

protocol EventProtocol {
    var eventDate : String { get set }
    var eventType : EventType { get set }
    var eventDiscription : String { get set }
}

class Event : EventProtocol {
    var eventDate = String()
    var eventType : EventType
    var eventDiscription : String
    var isActual : Bool
    
    init(eventDate: String, eventType: EventType, eventDiscription : String, isActual : Bool ) {
        self.eventDate = eventDate
        self.eventType = eventType
        self.eventDiscription = "Краткое описание события"
        self.isActual = isActual
    }
}


