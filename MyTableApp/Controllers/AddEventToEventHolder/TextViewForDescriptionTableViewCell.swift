//
//  TextViewForDescriptionTableViewCell.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 15.12.2022.
//

import UIKit

class TextViewForDescriptionTableViewCell: UITableViewCell {

    var eventDescriptionTextView = UITextView(frame: .zero)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        eventDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(eventDescriptionTextView)
        NSLayoutConstraint.activate([eventDescriptionTextView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
                                     eventDescriptionTextView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
                                     eventDescriptionTextView.leadingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
                                     eventDescriptionTextView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0)])
        eventDescriptionTextView.text = "sfdvfvsdv dfvfdsv"
        
        eventDescriptionTextView.textColor = .red    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        
    }

    
    
    
}
