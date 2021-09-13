//
//  ConnectionMonitorService.swift
//  NewsFeedApp
//
//  Created by Alex on 9/9/21.
//

import Foundation
import Network

final class ConnectionMonitorService {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: StringConstants.internetConnectionMonitor)
    
    static let shared = ConnectionMonitorService()
    
    init(){}
    
    public func monitorConnection(completionHandler: @escaping (NWPath.Status) -> Void) {
        monitor.pathUpdateHandler = { pathUpdateHandler in
                    
            switch pathUpdateHandler.status {
            case .satisfied:
                completionHandler(.satisfied)
                break
            default:
                completionHandler(.unsatisfied)
                break
            }
        }
        
        monitor.start(queue: queue)
    }
}
