import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import GeoKitMacros

final class InitMacroTests: XCTestCase {
    func testInitMacro() throws {
        assertMacroExpansion(
            #"""
            
            @Init
            class Test {
                let name: String
                let year: Int?
            }
            
            """#,
            expandedSource: #"""
            class Test {
                let name: String
                let year: Int?
            
                init(
                    name: String,
                    year: Int?
                ) {
                    self.name = name
                    self.year = year
                }
            }
            """#,
            macros: testableMacros
        )
    }
}
