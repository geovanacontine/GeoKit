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
                .elements.first?.name.text
            })
        
        let membersSyntax = members.map { member in
            "case .\(member): await mapper.\(member)()"
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
