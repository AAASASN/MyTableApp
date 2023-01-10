//
//  AddEventButtonAsTableViewCell.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 15.09.2022.
//

import UIKit

class AddEventButtonAsTableViewCell: UITableViewCell {

    var buttonLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        buttonAndButtonLabelSettings()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func buttonAndButtonLabelSettings() {
        
        self.contentView.backgroundColor = UIColor(red: 0.28, green: 0.52, blue: 0.80, alpha: 1.00)
        
        buttonLabel = {
            let buttonLabel = UILabel(frame: .zero)
            buttonLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(buttonLabel)
            NSLayoutConstraint.activate([buttonLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                                         buttonLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)])
            return buttonLabel
        }()
        
        buttonLabel.textColor = .white
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
