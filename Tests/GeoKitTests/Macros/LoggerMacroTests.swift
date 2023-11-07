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
                error: "Unexpected error!",
                category: "Account"
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
                let logger = Logger(subsystem: GeoLogger.shared.subsystem, category: "Account")
                let startTime = Date.now

                do {
                    logger.info("Doing something")
                    let result = try await exampleFunction(prm1: prm1, var2: var2)

                    let endTime = Date.now
                    let durationTimeInterval = endTime.timeIntervalSince(startTime)
                    let durationInSeconds = String(format: "%.1f", durationTimeInterval)
                    logger.info("Done successfully! [\(durationInSeconds)s]")

                    return result
                } catch {
                    let errorString = error as CustomStringConvertible
                    let errorDescription = errorString.description
                    logger.error("Unexpected error!. Error: \(errorDescription)")
                    throw error
                }
            }
            """#,
            macros: testableMacros
        )
    }
}
