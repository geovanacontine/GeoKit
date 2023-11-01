import CloudKit

struct CKService {
    
    private let container: CKContainer
    private let database: CKDatabase
    
    init(
        identifier: String,
        databaseType: CKDatabaseType
    ) {
        container = .init(identifier: identifier)
        database = container.database(forType: databaseType)
    }
}

// MARK: - CREATE API

extension CKService {
    func create<T: CKModel>(_ record: T) async throws {
        try await database.save(record.encodeToCKRecord())
    }
}

// MARK: - READ API

extension CKService {
    func fetch<T: CKModel>(id: String) async throws -> T {
        let record = try await database.record(for: .init(recordName: id))
        return try T.init(record: record)
    }
    
    func fetch<T: CKModel>(ids: [String]) async throws -> [T] {
        let recordsId = ids.map({ CKRecord.ID(recordName: $0) })
        let result = try await database.records(for: recordsId)
        let records = try result.map({ try $0.value.get() })
        return try records.map({ try T.init(record: $0) })
    }
    
    func fetch<T: CKModel>(predicate: NSPredicate) async throws -> [T] {
        let recordType = String(describing: T.self)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        let records = await database.fetchAll(withQuery: query)
        return try records.map({ try T.init(record: $0) })
    }
    
    func fetchAll<T: CKModel>() async throws -> [T] {
        try await fetch(predicate: .init(value: true))
    }
}

// MARK: - UPDATE API

extension CKService {
    func update<T: CKModel>(_ record: T) async throws {
        _ = try await database.modifyRecords(saving: [ record.encodeToCKRecord() ], deleting: [], savePolicy: .allKeys)
    }
}

// MARK: - DELETE API

extension CKService {
    func delete(id: String) async throws {
        try await database.deleteRecord(withID: .init(recordName: id))
    }
}
