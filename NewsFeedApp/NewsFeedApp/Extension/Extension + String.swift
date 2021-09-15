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

        guard let date: Date = dateFormatterGet.date(from: self) else { return ""}
        
        return dateFormatterPrint.string(from: date);
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var removedHTMLTags: String {
        return self.replacingOccurrences(of: "<[^>]+>",
                                         with: "",
                                         options: .regularExpression,
                                         range: nil)
    }
}
