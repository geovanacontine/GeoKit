import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import GeoKitMacros

final class CloudKitMacroTests: XCTestCase {
    func testCloudKitModelMacro() throws {
        assertMacroExpansion(
            #"""
            
            @CKModel
            public struct TestModel {
                let id: String
                let property1: String
                let property2: Double?
                
                var test: String {
                    "testString"
                }
            
                @CKDerivedProperty(query: "NSPredicate(value: true)")
                var property3: String?
            }
            
            """#,
            expandedSource: #"""
            public struct TestModel {
                let id: String
                let property1: String
                let property2: Double?
                
                var test: String {
                    "testString"
                }
                var property3: String?

                public func encodeToCKRecord() -> CKRecord {
                    let record = CKRecord(recordType: "TestModel", recordID: .init(recordName: id))
                    record.setValue(property1, forKey: "property1")
                    record.setValue(property2, forKey: "property2")
                    return record
                }

                public init(record: CKRecord) throws {
                    id = record.recordID.recordName
                    property1 = try record.decoded(forKey: "property1")
                    property2 = record.decodedOptional(forKey: "property2")
                }

                public mutating func fetchDerivedProperties() async throws {
                    property3 = try await CKContext.shared.fetch(withPredicate: NSPredicate(value: true)).first
                }
            }

            extension TestModel: CKModel {
            }
            """#,
            macros: testableMacros
        )
    }
}
