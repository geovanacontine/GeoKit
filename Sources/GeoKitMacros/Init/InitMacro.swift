import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct InitMacro: MemberMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        
        let classDecl = declaration.as(ClassDeclSyntax.self)
        let structDecl = declaration.as(StructDeclSyntax.self)
        
        let decl: ObjectProtocol? = classDecl ?? structDecl
        
        guard let decl else { throw InitMacroError.invalidType }
        let parameters = generateParameters(decl: decl)
        
        return [
            """
            \(raw: parameters.privacy) init(
            \(raw: parameters.initDeclaration.joined(separator: ",\n"))
            ) {
            \(raw: parameters.propertiesDeclaration.joined(separator: "\n"))
            }
            """
        ]
    }
    
    private static func generateParameters(
        decl: ObjectProtocol
    ) -> (
        privacy: String,
        initDeclaration: [String],
        propertiesDeclaration: [String]
    ) {
        let privacyModifier = decl.modifiers.first?.name.text
        let privacySyntax = privacyModifier ?? ""
        let members = decl.memberBlock.members
        
        let allVariables = members.compactMap { $0.decl.as(VariableDeclSyntax.self) }
        let validVariables = allVariables.filter({ $0.attributes.isEmpty })
        var variables = validVariables.compactMap({ $0.bindings })
        
        variables.removeAll(where: { $0.first?.accessorBlock != nil })
        
        let propertiesNames = variables.compactMap { variable in
            variable.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
        }
        
        let propertiesTypes = variables.compactMap { variable in
            if let nonOptional = variable.first?.typeAnnotation?.type.as(IdentifierTypeSyntax.self)?.name.text {
                return nonOptional
            }
            
            if let optional = variable.first?.typeAnnotation?.type.as(OptionalTypeSyntax.self)?.wrappedType.as(IdentifierTypeSyntax.self)?.name.text {
                return "\(optional)?"
            }
            
            return nil
        }
        
        var initDeclaration: [String] = []
        
        for (name, type) in zip(propertiesNames, propertiesTypes) {
            initDeclaration.append("\(name): \(type)")
        }
        
        let propertiesDeclaration: [String] = propertiesNames.compactMap { property in
            "self.\(property) = \(property)"
        }
        
        return (privacySyntax, initDeclaration, propertiesDeclaration)
    }
}

protocol ObjectProtocol {
    var modifiers: DeclModifierListSyntax { get }
    var memberBlock: MemberBlockSyntax { get }
}

extension ClassDeclSyntax: ObjectProtocol {}
extension StructDeclSyntax: ObjectProtocol {}
