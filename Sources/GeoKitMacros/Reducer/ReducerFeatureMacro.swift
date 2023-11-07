import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct ReducerFeatureMacro: MemberMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        
        guard let structDecl = declaration.as(StructDeclSyntax.self) else { return [] }
        
        let identifier = structDecl.name.text
        
        let members = structDecl
            .memberBlock
            .members.first(where: { $0.decl.is(EnumDeclSyntax.self) })?
            .decl.as(EnumDeclSyntax.self)?
            .memberBlock.members
            .compactMap({
                $0.as(MemberBlockItemSyntax.self)?
                .decl.as(EnumCaseDeclSyntax.self)?
                .elements.first
            }) ?? []

        let membersSyntax = members.map { member in
            let parameters = member.parameterClause?.parameters.compactMap({ $0.firstName?.text }) ?? []
            
            if parameters.isEmpty {
                return "case .\(member.name.text): await reducer.\(member.name.text)(state: &state)"
            } else {
                let parametersLeftSyntax = parameters.map({ "let \($0)" })
                let leftSyntax = parametersLeftSyntax.joined(separator: ", ")
                
                let parametersRightSyntax = parameters.map({ "\($0): \($0)" })
                let rightSyntax = parametersRightSyntax.joined(separator: ", ")
                return "case .\(member.name.text)(\(leftSyntax)): await reducer.\(member.name.text)(\(rightSyntax), state: &state)"
            }
        }
        
        return [
            """
            private let effects: \(raw: identifier)Effects
            private let reducer: \(raw: identifier)Reducer
            
            init() {
                effects = .init()
                reducer = .init(effects: effects)
            }
            
            func reduce(state: inout State, action: Action) async {
                switch action {
                \(raw: membersSyntax.joined(separator: "\n"))
                }
            }
            """
        ]
    }
}
