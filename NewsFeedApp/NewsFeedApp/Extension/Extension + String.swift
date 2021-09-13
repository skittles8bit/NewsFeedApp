//
//  Extension.swift
//  NewsFeedApp
//
//  Created by Alex on 9/7/21.
//

import Foundation

extension String {
    func getFormattedDate() -> String {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MM-dd-yyyy HH:mm"

        let date: Date? = dateFormatterGet.date(from: self)
        
        return dateFormatterPrint.string(from: date!);
    }
}
