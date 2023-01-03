//
//  Extensions.swift
//  MyTableApp
//
//  Created by Александр Мараенко on 18.12.2022.
//

import Foundation
import UIKit


// расширение UIViewController
extension UIViewController {
    
    // метод корректрно отображает событие в котором не задан год
    func formatDateWithoutYear(eventDate : String) -> String {
        let word = eventDate.reversed()
        var charArray = ""
        for char in word {
            if char != " " {
                charArray.append(char)
            } else {
                break
            }
        }
        if charArray != "1000" {
            return eventDate
        } else {
            let firstCharIndex = word.startIndex
            let fourthCharIndex = word.index(firstCharIndex, offsetBy:4)
            let lastCharIndex = word.index(firstCharIndex, offsetBy: word.count-1)
            let newWord = word[fourthCharIndex...lastCharIndex]
            return String(newWord.reversed())
        }
    }
    
    
}

