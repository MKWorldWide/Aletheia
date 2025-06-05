import Foundation
import CryptoKit

struct UserProfile: Codable {
    let id: UUID
    var name: String
    var purpose: String
    var offering: String
    var createdAt: Date
    
    init(name: String, purpose: String, offering: String) {
        self.id = UUID()
        self.name = name
        self.purpose = purpose
        self.offering = offering
        self.createdAt = Date()
    }
}

// MARK: - Secure Storage Service
class SecureStorage {
    private static let keychainService = "com.aelethia.app"
    
    static func saveProfile(_ profile: UserProfile) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(profile)
        
        // Encrypt the data
        let key = SymmetricKey(size: .bits256)
        let sealedBox = try AES.GCM.seal(data, using: key)
        
        // Store encrypted data
        UserDefaults.standard.set(sealedBox.combined?.base64EncodedString(), forKey: "encryptedProfile")
        
        // Store encryption key in Keychain
        try KeychainService.save(key: "profileKey", data: key.withUnsafeBytes { Data($0) })
    }
    
    static func loadProfile() throws -> UserProfile? {
        guard let encryptedString = UserDefaults.standard.string(forKey: "encryptedProfile"),
              let encryptedData = Data(base64Encoded: encryptedString),
              let keyData = try? KeychainService.load(key: "profileKey"),
              let key = SymmetricKey(data: keyData) else {
            return nil
        }
        
        let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        
        let decoder = JSONDecoder()
        return try decoder.decode(UserProfile.self, from: decryptedData)
    }
}

// MARK: - Keychain Service
enum KeychainService {
    static func save(key: String, data: Data) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: SecureStorage.keychainService,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.saveFailed
        }
    }
    
    static func load(key: String) throws -> Data {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: SecureStorage.keychainService,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data else {
            throw KeychainError.loadFailed
        }
        
        return data
    }
}

enum KeychainError: Error {
    case saveFailed
    case loadFailed
} 