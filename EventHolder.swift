//
//  EventHolder.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 15.07.2022.
//

import Foundation

protocol EventHolderProtocol: Codable {
    var eventHolderID : String { get set }
    var eventHolderFirstName : String { get set }
    var eventHolderLastName : String { get set }
    var eventHolderBirthdayDate : CustomDate { get set }
    var eventHolderPhoneNumber : String { get set }
    var eventHolderSex : EventHolderSex { get set }
    var eventHolderStatus : EventHolderStatus { get set }
    var events : [EventProtocol] { get set }
}

class EventHolder: Codable {
    var eventHolderID : String
    var eventHolderFirstName: String
    var eventHolderLastName: String
    var eventHolderBirthdayDate: CustomDate
    var eventHolderPhoneNumber: String
    var eventHolderSex: EventHolderSex
    var eventHolderStatus: EventHolderStatus
    var events = [Event]()

    init(eventHolderFirstName : String,
         eventHolderLastName : String,
         eventHolderBirthdayDate : CustomDate,
         eventHolderPhoneNumber : String,
         eventHolderSex : EventHolderSex,
         eventHolderStatus : EventHolderStatus,
         events : [Event] ) {
        self.eventHolderID = "EventHolderID_" + String(Int(Date().timeIntervalSince1970))
        self.eventHolderFirstName = eventHolderFirstName
        self.eventHolderLastName = eventHolderLastName
        self.eventHolderBirthdayDate = eventHolderBirthdayDate
        self.eventHolderPhoneNumber = eventHolderPhoneNumber
        self.eventHolderSex = eventHolderSex
        self.eventHolderStatus = eventHolderStatus
        self.events = events
    }
}
  


    



