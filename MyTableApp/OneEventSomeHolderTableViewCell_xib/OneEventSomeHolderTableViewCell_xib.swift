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
    @IBOutlet weak var isActualLabel: UILabel!
    @IBOutlet weak var switchOutlet: UISwitch!
    
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
