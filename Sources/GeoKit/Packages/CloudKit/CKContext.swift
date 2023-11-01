import Foundation

public class CKContext {
    
    private var service: CKService
    private let cache = CKCache()
    
    public static let shared = CKContext()
    
    private init() {
        service = .init(identifier: "defaultIdentifier", databaseType: .public)
    }
    
    public func setup(identifier: String, databaseType: CKDatabaseType) {
        service = .init(identifier: identifier, databaseType: databaseType)
    }
}

// MARK: - API

public extension CKContext {
    
    func fetch<T: CKModel>(
        withPredicate predicate: NSPredicate,
        withDerivedProperties: Bool = true
    ) async throws -> [T] {
        let records: [T] = try await fetchWithCache(predicate: predicate)
        return withDerivedProperties ? try await fetchWithDerivedProperties(records: records) : records
    }
    
    func create<T: CKModel>(_ model: T) async throws {
        try await service.create(model)
        cache.add(model.encodeToCKRecord())
    }
    
    func update<T: CKModel>(_ model: T) async throws {
        try await service.update(model)
    }
    
    func delete<T: CKModel>(_ model: T) async throws {
        try await service.delete(id: model.id)
        cache.remove(model.encodeToCKRecord())
    }
}

// MARK: - Cache

private extension CKContext {
    func fetchWithCache<T: CKModel>(predicate: NSPredicate) async throws -> [T] {
        let remoteData: [T] = try await service.fetch(predicate: predicate)
        let cachedData = cache.fetchAll()
        
        let oldCacheList = cachedData.filter { cachedRecord in
            remoteData.contains(where: { $0.id == cachedRecord.recordID.recordName })
        }
        
        for oldCache in oldCacheList {
            cache.remove(oldCache)
        }
        
        let validCache = cache.fetchAll().compactMap({ try? T.init(record: $0) })
        return remoteData + validCache
    }
    
    func fetchWithDerivedProperties<T: CKModel>(records: [T]) async throws -> [T] {
        var populatedRecords: [T] = []
        
        try await withThrowingTaskGroup(of: T.self) { [records] group in
            for index in records.enumerated() {
                group.addTask {
                    var ckCopy = records[index.offset]
                    try await ckCopy.fetchDerivedProperties()
                    return ckCopy
                }
            }
            
            for try await result in group {
                populatedRecords.append(result)
            }
        }
        
        return populatedRecords
    }
}
