//
//  NetworkHelper.swift
//  Sporix
//
//  Created by User on 03/06/2025.
//

import Foundation
import Reachability

class NetworkHelper {
    
    static let shared = NetworkHelper()
    
    private let reachability = try! Reachability()
    
    private init() {
        setupReachability()
    }
    
    private func setupReachability() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Connected via WiFi")
            } else if reachability.connection == .cellular {
                print("Connected via Cellular")
            }
        }
        
        reachability.whenUnreachable = { _ in
            print("Network not reachable")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func isNetworkAvailable() -> Bool {
        return reachability.connection != .unavailable
    }
}
