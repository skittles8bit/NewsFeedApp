//
//  Extension.swift
//  NewsFeedApp
//
//  Created by Alex on 9/7/21.
//

import Foundation

extension String {
    func convertData() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        guard let date = dateFormatter.date(from: self) else { return self }
        
        return dateFormatter.string(from: date)
    }
}
