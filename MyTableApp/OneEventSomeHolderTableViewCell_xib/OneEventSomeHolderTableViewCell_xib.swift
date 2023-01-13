//
//  OneEventSomeHolderTableViewCell_xib.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 21.09.2022.
//

import UIKit

class OneEventSomeHolderTableViewCell_xib: UITableViewCell {
    
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var dayCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var isActualLabel: UILabel!
    @IBOutlet weak var switchOutlet: UISwitch!
    
    // свойство для загрузки в него хранилища с данными
    var eventsStorage: EventStorageProtocol = EventStorage()
    var eventID = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        eventsStorage.getUpdatedDataToEventStorage()
        // tableView.reloadData()
    }
    
    func configLabelsAndColorStile(eventID: String) {
        
        eventsStorage.getUpdatedDataToEventStorage()
        
        self.eventID = eventID
        
        // MARK: - конфигурация ячейки и лейблов
        
        //self.contentView.backgroundColor = UIColor.systemGray5
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
//        self.contentView.layer.borderColor = UIColor.systemGray4.cgColor
//        self.contentView.layer.borderWidth = 4
        
        eventTypeLabel.backgroundColor = UIColor(red: 0.83, green: 0.77, blue: 0.98, alpha: 0.61)
        eventTypeLabel.layer.cornerRadius = 8
        eventTypeLabel.layer.masksToBounds = true
//        eventTypeLabel.layer.borderColor = UIColor.systemGray2.cgColor
//        eventTypeLabel.layer.borderWidth = 2
        
        eventDateLabel.backgroundColor = UIColor(red: 0.83, green: 0.77, blue: 0.98, alpha: 0.61)
        eventDateLabel.layer.cornerRadius = 8
        eventDateLabel.layer.masksToBounds = true
//        eventDateLabel.layer.borderColor = UIColor.systemGray2.cgColor
//        eventDateLabel.layer.borderWidth = 2
        
        dayCountLabel.backgroundColor = UIColor(red: 0.98, green: 0.82, blue: 0.76, alpha: 0.61) // UIColor(red: 1.00, green: 0.95, blue: 0.74, alpha: 0.61)
        dayCountLabel.layer.cornerRadius = 8
        dayCountLabel.layer.masksToBounds = true
//        dayCountLabel.layer.borderColor = UIColor.systemGray2.cgColor
//        dayCountLabel.layer.borderWidth = 2
        
        isActualLabel.backgroundColor = UIColor(red: 0.83, green: 0.77, blue: 0.98, alpha: 0.61)
        isActualLabel.layer.cornerRadius = 8
        isActualLabel.layer.masksToBounds = true
//        isActualLabel.layer.borderColor = UIColor.systemGray2.cgColor
//        isActualLabel.layer.borderWidth = 2
        
        descriptionLabel.backgroundColor = UIColor(red: 0.83, green: 0.77, blue: 0.98, alpha: 0.61)
        descriptionLabel.layer.cornerRadius = 8
        descriptionLabel.layer.masksToBounds = true
//        descriptionLabel.layer.borderColor = UIColor.systemGray2.cgColor
//        descriptionLabel.layer.borderWidth = 2
        
        // MARK: - настройка свича
        if eventsStorage.getEventFromStorageByEventID(eventID: self.eventID).isActual{
            //switchOutlet.setOn(true, animated: true)
            switchOutlet.isOn = true
        } else {
            //switchOutlet.setOn(false, animated: true)
            switchOutlet.isOn = false
        }
        
        // MARK: - наполнение лейблов
        eventDateLabel.text = "  " +  formatDateWithoutYear(eventDate:  (eventsStorage.getEventFromStorageByEventID(eventID: self.eventID)).eventDate.dateAsString
        )
        
        dayCountLabel.text = String((eventsStorage.getEventFromStorageByEventID(eventID: self.eventID)).eventDate.daysCountBeforeEvent)
        
        eventTypeLabel.text = "  " + (eventsStorage.getEventFromStorageByEventID(eventID: self.eventID)).eventType.rawValue
        descriptionLabel.text = "  " + (eventsStorage.getEventFromStorageByEventID(eventID: self.eventID)).eventDiscription
        if (eventsStorage.getEventFromStorageByEventID(eventID: self.eventID)).isActual {
            isActualLabel.text = "  Актуально"
            isActualLabel.backgroundColor = UIColor(red: 0.76, green: 1.00, blue: 0.89, alpha: 0.61)
            dayCountLabel.backgroundColor = UIColor(red: 0.76, green: 1.00, blue: 0.89, alpha: 0.61)
        } else {
            isActualLabel.text = "  Не актуально"
            isActualLabel.backgroundColor = UIColor(red: 0.98, green: 0.82, blue: 0.76, alpha: 0.61)
            dayCountLabel.backgroundColor = UIColor(red: 0.98, green: 0.82, blue: 0.76, alpha: 0.61)
        }
    }
    
    
    @IBAction func switchAction(_ sender: UISwitch) {
        if switchOutlet.isOn == true {
            print("switch was ON")
            let someEvent = eventsStorage.getEventFromStorageByEventID(eventID: eventID)
            eventsStorage.changeIsActualStatusForCurrentEvent(event: someEvent)
            eventsStorage.getUpdatedDataToEventStorage()
            switchOutlet.isOn = true
            isActualLabel.text = "  Актуально"
            isActualLabel.backgroundColor = UIColor(red: 0.76, green: 1.00, blue: 0.89, alpha: 0.61)
            dayCountLabel.backgroundColor = UIColor(red: 0.76, green: 1.00, blue: 0.89, alpha: 0.61)

        } else {
            print("switch was OFF")
            let someEvent = eventsStorage.getEventFromStorageByEventID(eventID: eventID)
            eventsStorage.changeIsActualStatusForCurrentEvent(event: someEvent)
            eventsStorage.getUpdatedDataToEventStorage()
            switchOutlet.isOn = false
            isActualLabel.text = "  Не актуально"
            isActualLabel.backgroundColor = UIColor(red: 0.98, green: 0.82, blue: 0.76, alpha: 0.61)
            dayCountLabel.backgroundColor = UIColor(red: 0.98, green: 0.82, blue: 0.76, alpha: 0.61)

          }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // метод корректрно отображает событие в котором не задан год
    func formatDateWithoutYear(eventDate : String) -> String {
        let word = eventDate.reversed()
        var charArray = ""
        for char in word {
            if char != " " {
                charArray.append(char)
            } else {
                break
            }
        }
        if charArray != "1000" {
            return eventDate
        } else {
            let firstCharIndex = word.startIndex
            let fourthCharIndex = word.index(firstCharIndex, offsetBy:4)
            let lastCharIndex = word.index(firstCharIndex, offsetBy: word.count-1)
            let newWord = word[fourthCharIndex...lastCharIndex]
            return String(newWord.reversed())
        }
    }
    
}
