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
    
    public func monitorConnection(complitionHandler: @escaping (NWPath.Status) -> Void) {
        monitor.pathUpdateHandler = { pathUpdateHandler in
                    
            switch pathUpdateHandler.status {
            case .satisfied:
                complitionHandler(.satisfied)
                break
            default:
                complitionHandler(.unsatisfied)
                break
            }
        }
        
        monitor.start(queue: queue)
    }
}
