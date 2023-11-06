import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import GeoKitMacros

final class LoggerMacroTests: XCTestCase {
    func testLoggerMacro() throws {
        assertMacroExpansion(
            #"""
            
            @Logger(
                info: "Doing something",
                success: "Done successfully!",
                feature: "Account"
            )
            func exampleFunction(prm1: String, var2: Double) async throws -> String {
                "Do something"
            }
            
            """#,
            expandedSource: #"""
            func exampleFunction(prm1: String, var2: Double) async throws -> String {
                "Do something"
            }

            func exampleFunctionWithLogger(prm1: String, var2: Double) async throws -> String  {
                let logger = GeoLogger.shared.makeLogger(forCategory: "Account")

                do {
                    logger.info("Doing something")
                    let result = try await exampleFunction(prm1: prm1, var2: var2)
                    logger.notice("Done successfully!")
                    return result
                } catch {
                    GeoLogger.shared.error(error, logger: logger)
                    throw error
                }
            }
            """#,
            macros: testableMacros
        )
    }
}
