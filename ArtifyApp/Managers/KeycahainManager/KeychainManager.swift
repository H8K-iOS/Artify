import Foundation

class KeychainManager {
    static let shared = KeychainManager()
    private let service = "artify"
    private let account = "OPENAI_API_KEY"

    func saveApiKey(_ apiKey: String) {
        if let data = apiKey.data(using: .utf8) {
            KeychainHelper.standard.save(data, service: service, account: account)
        }
    }

    func getApiKey() -> String? {
        if let data = KeychainHelper.standard.read(service: service, account: account) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    func deleteApiKey() {
        KeychainHelper.standard.delete(service: service, account: account)
    }
}
