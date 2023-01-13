//
//  CongratulationViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 24.10.2022.
//

import UIKit

class CongratulationViewController: UIViewController {

    var textLabel: UILabel!
    var callButton: UIButton!
    var whiteView: UIView!

    var congratulationText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // настройка navigationItem.title в DetailedEventViewController
        self.navigationItem.title = "Поздравляем !!!"
        // настройка большого navigationItem.title в DetailedEventViewController
        self.navigationItem.largeTitleDisplayMode = .always
        
        
        settings()
        
        callButton.layer.cornerRadius = 10
        whiteView.layer.cornerRadius = 10
        textLabel.layer.cornerRadius = 10
        textLabel.text = congratulationText

    }
    

    func settings() {
        
        view.backgroundColor = .systemGray6
        
        whiteView = {
            let whiteView = UILabel(frame: .zero)
            whiteView.backgroundColor = .white
            whiteView.translatesAutoresizingMaskIntoConstraints = false
            return whiteView
        }()
        
        textLabel = {
            let textLabel = UILabel(frame: .zero)
            textLabel.numberOfLines = 0
            // textLabel.backgroundColor = .systemGray2
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            return textLabel
        }()
        
        callButton = {
            let callButton = UIButton(frame: .zero, primaryAction: UIAction(title: "Позвонить", handler: { _ in
                //
            }))
            callButton.translatesAutoresizingMaskIntoConstraints = false
            callButton.tintColor = .white
            callButton.backgroundColor = UIColor(red: 0.28, green: 0.52, blue: 0.80, alpha: 1.00)
            return callButton
        }()
        
        view.addSubview(whiteView)
        whiteView.addSubview(textLabel)
        view.addSubview(callButton)
        
        NSLayoutConstraint.activate([
                                      whiteView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
                                      whiteView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                                      whiteView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                                      whiteView.bottomAnchor.constraint(equalTo: self.callButton.safeAreaLayoutGuide.topAnchor, constant: -16),
                                     
                                     textLabel.topAnchor.constraint(equalTo: self.whiteView.topAnchor, constant: 16),
                                     textLabel.leadingAnchor.constraint(equalTo: self.whiteView.leadingAnchor, constant: 16),
                                     textLabel.trailingAnchor.constraint(equalTo: self.whiteView.trailingAnchor, constant: -16),
                                     textLabel.bottomAnchor.constraint(equalTo: self.whiteView.bottomAnchor, constant: -16),
                                    
                                     callButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                                     callButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                                     callButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                                     callButton.heightAnchor.constraint(equalToConstant: 60)
                                    ])
        
        
        }
    
    
}
