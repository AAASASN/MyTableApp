//
//  OneEventSomeHolderTableViewCell.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 01.09.2022.
//

import UIKit

class OneEventSomeHolderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var dayCountLabel: UILabel!
    @IBOutlet weak var isActual: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func switchAction(_ sender: UISwitch) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
