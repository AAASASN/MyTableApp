//
//  StartControllerCustomCell.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 08.07.2022.
//

import UIKit

class StartControllerCustomCell: UITableViewCell {

    var nameLabel: UILabel!
    var eventTypeLabel: UILabel!
    var dateLabel: UILabel!
    
    var firstStackView: UIStackView!
    var secondStackView: UIStackView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellContentSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellContentSettings() {
        
        self.accessoryType = .disclosureIndicator
        
        nameLabel = UILabel(frame: .zero)
        nameLabel.font = .systemFont(ofSize: 25)
        nameLabel.textColor = .darkGray
        
        eventTypeLabel = UILabel(frame: .zero)
        eventTypeLabel.font = .systemFont(ofSize: 12)
        eventTypeLabel.textColor = .systemGray2

        dateLabel = UILabel(frame: .zero)
        dateLabel.font = .systemFont(ofSize: 17)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textAlignment = .right
        dateLabel.textColor = .darkGray
        
        firstStackView = UIStackView()
        firstStackView.axis = .vertical
        
        firstStackView.distribution = .fillEqually
        firstStackView.alignment = .fill
        
        firstStackView.addArrangedSubview(nameLabel)
        firstStackView.addArrangedSubview(eventTypeLabel)

        secondStackView = UIStackView()
        secondStackView.translatesAutoresizingMaskIntoConstraints = false
        secondStackView.axis = .horizontal
        secondStackView.addArrangedSubview(firstStackView)
        secondStackView.addArrangedSubview(dateLabel)
        
        contentView.addSubview(secondStackView)
        
        NSLayoutConstraint.activate([secondStackView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16 ),
                                     secondStackView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 11),
                                     secondStackView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                                     secondStackView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor, constant: -11),
                                    ])
    }
    
}
