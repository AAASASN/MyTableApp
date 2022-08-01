//
//  ChangeEventHolderStatusCustomTableViewCell.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 29.07.2022.
//

import UIKit

class ChangeEventHolderStatusCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var statusNameLabel: UILabel!
    @IBOutlet weak var statusDescriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
