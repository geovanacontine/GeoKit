import CloudKit

public extension CKRecord {
    func decoded<T>(forKey key: String) throws -> T {
        guard let value: T = decodedOptional(forKey: key) else { throw CKServiceError.decodingError }
        return value
    }
    
    func decodedOptional<T>(forKey key: String) -> T? {
        self[key] as? T
    }
}
