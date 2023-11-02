import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct ReduxFeatureMacro: MemberMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else { return [] }
        
        var enumIdentifier = enumDecl.name.text
        
        // Remove "Action" from enum identifier
        if let range = enumIdentifier.range(of: "Action") {
            enumIdentifier.removeSubrange(range)
        }
        
        let members = enumDecl
            .memberBlock
            .members
            .compactMap({
                $0.as(MemberBlockItemSyntax.self)?
                .decl.as(EnumCaseDeclSyntax.self)?
                .elements.first
            })
        
        
        let membersSyntax = members.map { member in
            let parameters = member.parameterClause?.parameters.compactMap({ $0.firstName?.text }) ?? []
            
            if parameters.isEmpty {
                return "case .\(member.name.text): await mapper.\(member.name.text)()"
            } else {
                let parametersLeftSyntax = parameters.map({ "let \($0)" })
                let leftSyntax = parametersLeftSyntax.joined(separator: ", ")
                
                let parametersRightSyntax = parameters.map({ "\($0): \($0)" })
                let rightSyntax = parametersRightSyntax.joined(separator: ", ")
                return "case .\(member.name.text)(\(leftSyntax)): await mapper.\(member.name.text)(\(rightSyntax))"
            }
        }
        
        return [
            """
            func run(usingMapper mapper: \(raw: enumIdentifier)Mapper) async {
                switch self {
                \(raw: membersSyntax.joined(separator: "\n"))
                }
            }
            """
        ]
    }
}
