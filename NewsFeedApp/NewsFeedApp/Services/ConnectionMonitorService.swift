//
//  ConnectionMonitorService.swift
//  NewsFeedApp
//
//  Created by Alex on 9/9/21.
//

import Foundation
import Network

typealias ConnectionStatus = NWPath.Status

final class ConnectionMonitorService {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: StringConstants.internetConnectionMonitor)
    
    static let shared = ConnectionMonitorService()
    
    init(){}
    
    public func monitorConnection(completionHandler: @escaping (ConnectionStatus) -> Void) {
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
