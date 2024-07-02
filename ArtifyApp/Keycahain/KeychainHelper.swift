import Foundation
import Security
final class KeychainHelper {
    static let standard = KeychainHelper()
    private init() {}
    
    func save(_ data: Data, service: String, account: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: data
        ] as CFDictionary
        
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            print("Error: \(status)")
        }
    }
    
    func read(service: String, account: String) -> Data? {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecReturnData: true,
                kSecMatchLimit: kSecMatchLimitOne
            ] as CFDictionary
            
            var result: AnyObject?
            let status = SecItemCopyMatching(query, &result)
            
            if status == errSecSuccess {
                return result as? Data
            } else {
                print("Error: \(status)")
                return nil
            }
        }
    
    func delete(service: String, account: String) {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account
            ] as CFDictionary
            
            let status = SecItemDelete(query)
            if status != errSecSuccess {
                print("Error: \(status)")
            }
        }
}
