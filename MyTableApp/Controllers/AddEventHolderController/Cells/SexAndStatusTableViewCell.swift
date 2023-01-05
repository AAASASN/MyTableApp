//
//  SexAndStatusTableViewCell.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 09.09.2022.
//

import UIKit

class SexAndStatusTableViewCell: UITableViewCell {
    
    enum CellSexOrStatusType {
        case sex
        case status
    }

    var sexOrStatusLabel: UILabel!
    var selectResultLabel: UILabel!
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, cellType: CellSexOrStatusType) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        self.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        labelsSettings()
        
        switch cellType {
        case .sex:
            sexOrStatusLabel.text = "Пол"
            selectResultLabel.text = "sexLabel"
            selectResultLabel.textColor = .systemGray3
        case .status:
            sexOrStatusLabel.text = "Статус"
            selectResultLabel.text = "statusLabel"
            selectResultLabel.textColor = .systemGray3

        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SexAndStatusTableViewCell {
    
    func labelsSettings()  {
        
        sexOrStatusLabel = {
            let sexOrStatusLabel = UILabel(frame: .zero)
            contentView.addSubview(sexOrStatusLabel)
            sexOrStatusLabel.translatesAutoresizingMaskIntoConstraints = false
            return sexOrStatusLabel
        }()
        
        selectResultLabel = {
            let selectResultLabel = UILabel(frame: .zero)
            contentView.addSubview(selectResultLabel)
            selectResultLabel.translatesAutoresizingMaskIntoConstraints = false
            return selectResultLabel
        }()
        
        NSLayoutConstraint.activate([sexOrStatusLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
                                     sexOrStatusLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
                                     sexOrStatusLabel.trailingAnchor.constraint(equalTo: selectResultLabel.leadingAnchor, constant: -16),
                                     sexOrStatusLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
                                     selectResultLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
                                     selectResultLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
                                     selectResultLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0)
                                    ])
    }
}
