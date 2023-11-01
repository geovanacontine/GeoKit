import Foundation
import CloudKit

class CKCache {
    private var cached: [CKRecord] = []
    public init() {}
}

// MARK: - API

extension CKCache {
    func add(_ record: CKRecord) {
        cached.append(record)
    }
    
    func remove(_ record: CKRecord) {
        cached.removeAll(where: { $0.recordID.recordName == record.recordID.recordName })
    }
    
    func fetchAll() -> [CKRecord] {
        cached
    }
    
    func clean() {
        cached = []
    }
}
