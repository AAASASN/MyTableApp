//
//  DetailedEventViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 19.09.2022.
//

import UIKit

class DetailedEventViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var eventHolderAndEvent : (EventHolder, EventProtocol)!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // зарегистрируем Nib ячейки
        let cellNib = UINib(nibName: "OneEventSomeHolderTableViewCell_xib", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "reuseIdentifier")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailedEventViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellForReturn = UITableViewCell()
        
        if indexPath.section == 0 {
            let standartCell = tableView.dequeueReusableCell(withIdentifier: "CellForEventHolder")!
        
            var content = standartCell.defaultContentConfiguration()

            // Configure content.
            content.image = UIImage(systemName: "star")
            if eventHolderAndEvent != nil {
                content.text = eventHolderAndEvent.0.eventHolderFirstName + " " + eventHolderAndEvent.0.eventHolderLastName
                content.secondaryText = eventHolderAndEvent.0.eventHolderStatus.rawValue
            }
            // Customize appearance.
            content.imageProperties.tintColor = .purple

            standartCell.contentConfiguration = content
            
            cellForReturn = standartCell
        }
        
        if indexPath.section == 1 {
            
            let customCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") as! OneEventSomeHolderTableViewCell_xib

            // насторойка ячейки
            customCell.configLabelsAndColorStule(event: eventHolderAndEvent.1 )
            
            cellForReturn = customCell
        }
        return cellForReturn
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{ return 200
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            // получаем вью контроллер, в который происходит переход
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let aboutEventHolderController = storyboard.instantiateViewController(withIdentifier: "AddEventHolderViewControllerID") as! AddEventHolderViewController
            
            // настраиваем aboutEventHolderController перед вызовом - передадим экземпляр EventHolder и заполняем текстовые поля
            aboutEventHolderController.prepareForReqestFromDetailedEventViewController(someEventHolder: eventHolderAndEvent.0)
            
            // переходим к следующему экрану
            self.navigationController?.pushViewController(aboutEventHolderController, animated: true)        }
    }
}
