import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct ReduxMacro: MemberMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else { return [] }
        
        let members = enumDecl
            .memberBlock
            .members
            .compactMap({
                $0.as(MemberBlockItemSyntax.self)?
                .decl.as(EnumCaseDeclSyntax.self)?
                .elements.first?.name.text
            })
        
        let membersSyntax = members.map { member in
            "case .\(member)(let \(member)Action): await \(member)Action.run(usingMapper: .init(state: state))"
        }
        
        return [
            """
            static func run(_ action: Action, forState state: AppState = AppState.shared) async {
                switch action {
                \(raw: membersSyntax.joined(separator: "\n"))
                }
            }
            """
        ]
    }
}

extension ReduxMacro: PeerMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else { return [] }
        
        let members = enumDecl
            .memberBlock
            .members
            .compactMap({
                $0.as(MemberBlockItemSyntax.self)?
                .decl.as(EnumCaseDeclSyntax.self)?
                .elements.first?.name.text
            })
        
        let membersSyntax = members.map { member in
            "var \(member) = \(member.capitalized)State()"
        }
        
        return [
            """
            @Observable
            class AppState {
                
                \(raw: membersSyntax.joined(separator: "\n"))
                
                static let shared = AppState()
                private init() {}
            }
            """
        ]
    }
}
