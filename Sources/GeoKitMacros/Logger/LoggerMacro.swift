import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct LoggerMacro: PeerMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        
        guard let funcDecl = declaration.as(FunctionDeclSyntax.self) else { return [] }
        
        let identifier = funcDecl.name.text
        let hasThrows = funcDecl.signature.effectSpecifiers?.throwsSpecifier != nil
        let hasAsync = funcDecl.signature.effectSpecifiers?.asyncSpecifier != nil
        let awaitSyntax = hasAsync ? "await" : ""
        let asyncSyntax = hasAsync ? "async" : ""
        
        let parameters = funcDecl.signature.parameterClause.parameters.compactMap({ $0.as(FunctionParameterSyntax.self)?.firstName.text })
        let parametersSyntax = parameters.map({ "\($0): \($0)" }).joined(separator: ", ")
        let functionSyntax = identifier + "(\(parametersSyntax))"
        
        let hasReturn = funcDecl.signature.returnClause != nil
        let returnSyntax = hasReturn ? "return" : ""
        
        let attributes = funcDecl.attributes.first?.as(AttributeSyntax.self)?.arguments?.as(LabeledExprListSyntax.self)
        let attMessages = attributes?.compactMap({ $0.expression.as(StringLiteralExprSyntax.self)?.segments.first?.as(StringSegmentSyntax.self)?.content.text })
        
        let infoMessage = attMessages?[0] ?? ""
        let successMessage = attMessages?[1] ?? ""
        let errorMessage = attMessages?[2] ?? ""
        let logCategory = attMessages?[3] ?? ""
        
        if !hasThrows {
            return [
                """
                func \(raw: identifier)WithLogger() \(raw: asyncSyntax) {
                    let logger = Logger(subsystem: GeoLogger.shared.subsystem, category: "\(raw: logCategory)")
                    logger.info("\(raw: infoMessage)")
                    \(raw: returnSyntax) try \(funcDecl)
                    logger.info("\(raw: successMessage)")
                }
                """
            ]
        }
        
        return [
            """
            func \(raw: identifier)WithLogger\(funcDecl.signature) {
                let logger = Logger(subsystem: GeoLogger.shared.subsystem, category: "\(raw: logCategory)")
                let startTime = Date.now
            
                do {
                    logger.info("\(raw: infoMessage)")
                    let result = try \(raw: awaitSyntax) \(raw: functionSyntax)
            
                    let endTime = Date.now
                    let durationTimeInterval = endTime.timeIntervalSince(startTime)
                    let durationInSeconds = String(format: "%.1f", durationTimeInterval)
                    logger.info("\(raw: successMessage) [\\(durationInSeconds)s]")
            
                    \(raw: returnSyntax) result
                } catch {
                    let errorString = error as CustomStringConvertible
                    let errorDescription = errorString.description
                    logger.error("\(raw: errorMessage). Error: \\(errorDescription)")
                    throw error
                }
            }
            """
        ]
    }
}
