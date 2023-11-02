import Foundation

public protocol CKContextProtocol {
    func setup(identifier: String, databaseType: CKDatabaseType)
    func fetch<T: CKModel>(withPredicate predicate: NSPredicate, withDerivedProperties: Bool) async throws -> [T]
    func create<T: CKModel>(_ model: T) async throws
    func update<T: CKModel>(_ model: T) async throws
    func delete<T: CKModel>(_ model: T) async throws
}
