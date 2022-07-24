//
//  StartControllerCustomCell.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 08.07.2022.
//

import UIKit

class StartControllerCustomCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var friendStatusLabel: UILabel!
    @IBOutlet var eventTypeLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
