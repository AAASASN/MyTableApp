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
    var eventHolderBirthdayDate : Date { get set }
    var eventHolderPhoneNumber : String { get set }
    var sex : EventHolderSex { get set }
    var eventHolderStatus : EventHolderStatus { get set }
    var events : [EventProtocol] { get set }


}

class EventHolder : EventHolderProtocol {
    var eventHolderFirstName = String()
    var eventHolderLastName = String()
    var eventHolderBirthdayDate: Date
    var eventHolderPhoneNumber: String
    var sex: EventHolderSex
    var eventHolderStatus: EventHolderStatus
    var events: [EventProtocol]
    

    init(eventHolderFirstName : String,
         eventHolderLastName : String,
         eventHolderBirthdayDate : Date,
         eventHolderPhoneNumber : String,
         sex : EventHolderSex,
         eventHolderStatus : EventHolderStatus,
         events : [EventProtocol] ) {
        self.eventHolderFirstName = eventHolderFirstName
        self.eventHolderLastName = eventHolderLastName
        self.eventHolderBirthdayDate = eventHolderBirthdayDate
        self.eventHolderPhoneNumber = eventHolderPhoneNumber
        self.sex = EventHolderSex.none
        self.eventHolderStatus = eventHolderStatus
        self.events = events
    }
}


