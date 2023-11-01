import CloudKit

public enum CKDatabaseType {
    case `public`
    case shared
    case `private`
}

extension CKContainer {
    func database(forType type: CKDatabaseType) -> CKDatabase {
        switch type {
        case .public:
            return publicCloudDatabase
        case .shared:
            return sharedCloudDatabase
        case .private:
            return privateCloudDatabase
        }
    }
}
