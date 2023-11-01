import CloudKit

public protocol CKModel: Identifiable {
    var id: String { get }
    init(record: CKRecord) throws
    func encodeToCKRecord() -> CKRecord
    mutating func fetchDerivedProperties() async throws
}
