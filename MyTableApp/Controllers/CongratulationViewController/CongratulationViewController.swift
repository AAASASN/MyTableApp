//
//  CongratulationViewController.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 24.10.2022.
//

import UIKit

class CongratulationViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var whiteView: UIView!
    
    var congratulationText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // настройка аутлетов
        whiteView.layer.cornerRadius = 10
        callButton.layer.cornerRadius = 10
        textLabel.text = congratulationText
        
        // настройка navigationItem.title в DetailedEventViewController
        self.navigationItem.title = "Поздравляем !!!"
        // настройка большого navigationItem.title в DetailedEventViewController
        self.navigationItem.largeTitleDisplayMode = .always
    }
    

    @IBAction func callButtonTaped(_ sender: UIButton) {
        // здесь будет осуществляться звонок юбиляру
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
