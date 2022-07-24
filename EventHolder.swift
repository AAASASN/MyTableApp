//
//  EventHolder.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 15.07.2022.
//

import Foundation

protocol EventHolderProtocol {
    var eventHolderFirstName : String { get set }
    var eventHolderLastName : String { get set }
    var eventHolderStatus : EventHolderStatus { get set }
    var events : [EventProtocol] { get set }
    var eventHolderPhoneNumber : String { get set }
    var sex : Bool { get set }
}

class EventHolder : EventHolderProtocol {
    var eventHolderFirstName = String()
    var eventHolderLastName = String()
    var eventHolderStatus: EventHolderStatus
    var events: [EventProtocol]
    var eventHolderPhoneNumber: String
    var sex: Bool

    init(eventHolderFirstName : String, eventHolderLastName : String, eventHolderStatus : EventHolderStatus, events : [EventProtocol], eventHolderPhoneNumber : String, sex : Bool) {
        self.eventHolderFirstName = eventHolderFirstName
        self.eventHolderLastName = eventHolderLastName
        self.eventHolderStatus = eventHolderStatus
        self.events = events
        self.eventHolderPhoneNumber = eventHolderPhoneNumber
        self.sex = sex
    }
}


