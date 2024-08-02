import Network
import UIKit

final class NetworkMonitor {
   static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor: NWPathMonitor
    
    private(set) var connectionType: ConnectionType?
    private(set) var isConected: Bool = false
    
    enum ConnectionType {
        case wifi
        case celular
        case internet
        case unknown
    }
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConected = path.status == .satisfied
            self?.getConnectionType(path)
            NotificationCenter.default.post(name: .networkChanged, object: nil)
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        }
        
        else if path.usesInterfaceType(.cellular) {
            connectionType = .celular
        }
        
        else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .internet
        } 
        else {
            connectionType = .unknown
        }
    }
}

extension Notification.Name {
    static let networkChanged = Notification.Name("networkChanged")
}
