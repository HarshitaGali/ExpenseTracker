//
//  Extensions.swift
//  ExpenseTracker
//
//  Created by Harshita Gali on 30/09/2022.
//

import Foundation
import SwiftUI

extension Color{
    static let background = Color("Background")
    static let icon = Color("Icon")
    static let text = Color("Text")
    static let systemBackground = Color(uiColor: .systemBackground)
}

extension DateFormatter {
    static let allNumericUSA : DateFormatter = {
        
        let formater = DateFormatter()
        formater.dateFormat = "MM/dd/YYYY"
        
        return formater
    }()
}

extension String {
    func dateParsed() -> Date{
        
        guard let parsedDate = DateFormatter.allNumericUSA.date(from: self) else {return Date()}
        
        return parsedDate
    }
    }

extension Date : Strideable {
    func formatted()-> String{
        return self.formatted(.dateTime.year().month().day())
    }
}

extension Double{
    func roundedTo2Digits() -> Double{
        return (self * 100).rounded() / 100
    }
}
