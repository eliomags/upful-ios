//
//  NetworkMonitor.swift
//  Jyanik
//
//  Network connectivity monitoring using NWPathMonitor
//

import Foundation
import Network
import Observation

// MARK: - Connection Type

enum ConnectionType {
    case wifi
    case cellular
    case wired
    case none
}

// MARK: - Network Monitor

@Observable
final class NetworkMonitor {

    static let shared = NetworkMonitor()

    private(set) var isConnected: Bool = true
    private(set) var connectionType: ConnectionType = .wifi

    private let monitor: NWPathMonitor
    private let monitorQueue = DispatchQueue(label: "com.jyanik.networkMonitor", qos: .utility)

    init() {
        monitor = NWPathMonitor()
        startMonitoring()
    }

    deinit {
        stopMonitoring()
    }

    // MARK: - Monitoring

    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            let connected = path.status == .satisfied
            let type = self.resolveConnectionType(from: path)

            Task { @MainActor in
                self.isConnected = connected
                self.connectionType = type
            }
        }
        monitor.start(queue: monitorQueue)
    }

    private func stopMonitoring() {
        monitor.cancel()
    }

    private func resolveConnectionType(from path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .wired
        } else {
            return .none
        }
    }
}
