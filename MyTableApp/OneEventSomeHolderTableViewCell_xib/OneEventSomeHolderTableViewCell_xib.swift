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
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configLabelsAndColorStule(event: EventProtocol) {
        
        // MARK: - конфигурация ячейки и лейблов
        
        
        
        //self.contentView.backgroundColor = UIColor.systemGray5
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderColor = UIColor.systemGray4.cgColor
        self.contentView.layer.borderWidth = 5
        
        eventTypeLabel.backgroundColor = UIColor(red: 0.83, green: 0.77, blue: 0.98, alpha: 0.61)
        eventTypeLabel.layer.cornerRadius = 15
        eventTypeLabel.layer.masksToBounds = true
        eventTypeLabel.layer.borderColor = UIColor.systemGray2.cgColor
        eventTypeLabel.layer.borderWidth = 2
        
        eventDateLabel.backgroundColor = UIColor(red: 0.83, green: 0.77, blue: 0.98, alpha: 0.61)
        eventDateLabel.layer.cornerRadius = 15
        eventDateLabel.layer.masksToBounds = true
        eventDateLabel.layer.borderColor = UIColor.systemGray2.cgColor
        eventDateLabel.layer.borderWidth = 2
        
        dayCountLabel.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.74, alpha: 0.61)
        dayCountLabel.layer.cornerRadius = 20
        dayCountLabel.layer.masksToBounds = true
        dayCountLabel.layer.borderColor = UIColor.systemGray2.cgColor
        dayCountLabel.layer.borderWidth = 2
        
        isActualLabel.backgroundColor = UIColor(red: 0.83, green: 0.77, blue: 0.98, alpha: 0.61)
        isActualLabel.layer.cornerRadius = 15
        isActualLabel.layer.masksToBounds = true
        isActualLabel.layer.borderColor = UIColor.systemGray2.cgColor
        isActualLabel.layer.borderWidth = 2
        
        descriptionLabel.backgroundColor = UIColor(red: 0.83, green: 0.77, blue: 0.98, alpha: 0.61)
        descriptionLabel.layer.cornerRadius = 15
        descriptionLabel.layer.masksToBounds = true
        descriptionLabel.layer.borderColor = UIColor.systemGray2.cgColor
        descriptionLabel.layer.borderWidth = 2
        
        // MARK: - настройка свича
        if event.isActual {
            switchOutlet.setOn(true, animated: true)
            //switchOutlet.isOn = true
        } else {
            switchOutlet.setOn(false, animated: true)
            //switchOutlet.isOn = false
        }
        
        // MARK: - наполнение лейблов
        eventDateLabel.text = "  " + event.eventDate.dateAsString
        dayCountLabel.text = String(event.eventDate.daysCountBeforeEvent)
        eventTypeLabel.text = "  " + event.eventType.rawValue
        descriptionLabel.text = "  Какое-то описание"
        if event.isActual {
            isActualLabel.text = "  Актуально"
            isActualLabel.backgroundColor = UIColor(red: 0.76, green: 1.00, blue: 0.89, alpha: 0.61)
        } else {
            isActualLabel.text = "  Не актуально"
            isActualLabel.backgroundColor = UIColor(red: 0.98, green: 0.82, blue: 0.76, alpha: 0.61)
        }
    }
    
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        
        // Configure the view for the selected state
    }
    
}
