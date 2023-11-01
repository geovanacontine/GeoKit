import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// MARK: - MemberMacro

public struct CKModelMacro: MemberMacro {
    
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        
        guard let structDecl = declaration.as(StructDeclSyntax.self) else { throw CKMacroError.notStructType }
        
        let modelName = structDecl.name.text
        
        let privacyModifier = structDecl.modifiers.first?.name.text
        let privacySyntax = privacyModifier ?? ""
        
        let allMembers = structDecl.memberBlock.members.compactMap({ $0.as(MemberBlockItemSyntax.self)?.decl.as(VariableDeclSyntax.self) })
        
        // Ignore CKDerivedProperty fields
        let validMembers = allMembers.filter({ $0.attributes.isEmpty })
        
        let bindings = validMembers.compactMap({ $0.bindings.first })
        
        // Ignore computed properties
        var membersToEncode = bindings.filter({ $0.accessorBlock == nil })
        
        var properties = membersToEncode.compactMap { member in
            member.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
        }
        
        guard let modelID = properties.first(where: { $0 == "id" }) else { throw CKMacroError.missingIdField }
        _ = properties.removeFirst()
        _ = membersToEncode.removeFirst()
        
        let propertiesEncodeSyntax = properties.map { property in
            "record.setValue(\(property), forKey: \"\(property)\")"
        }
        
        let propertiesDecodeSyntax: [String] = membersToEncode.compactMap { member in
            guard let property = member.pattern.as(IdentifierPatternSyntax.self)?.identifier.text else { return nil }
            
            let isOptional = member.typeAnnotation?.type.as(OptionalTypeSyntax.self) != nil
            
            if isOptional {
                return "    \(property) = record.decodedOptional(forKey: \"\(property)\")"
            } else {
                return "    \(property) = try record.decoded(forKey: \"\(property)\")"
            }
        }
        
        let derivedProperties = allMembers.filter({ !$0.attributes.isEmpty })
        let derivedPropertiesSyntax: [String] = derivedProperties.map { property in
            let name = property.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
            let query = property.attributes.first?.as(AttributeSyntax.self)?.arguments?.as(LabeledExprListSyntax.self)?.first?.expression.as(StringLiteralExprSyntax.self)?.segments.first?.as(StringSegmentSyntax.self)?.content.text
            return "\(name ?? "") = try await CKContext.shared.fetch(withPredicate: \(query ?? "")).first"
        }
        
        return [
            """
            \(raw: privacySyntax) func encodeToCKRecord() -> CKRecord {
            let record = CKRecord(recordType: \"\(raw: modelName)\", recordID: .init(recordName: \(raw: modelID)))
            \(raw: propertiesEncodeSyntax.joined(separator: "\n"))
            return record
            }
            
            \(raw: privacySyntax) init(record: CKRecord) throws {
                id = record.recordID.recordName
            \(raw: propertiesDecodeSyntax.joined(separator: "\n"))
            }
            
            \(raw: privacySyntax) mutating func fetchDerivedProperties() async throws {
                \(raw: derivedPropertiesSyntax.joined(separator: "\n"))
            }
            """
        ]
    }
}

// MARK: - ExtensionMacro

extension CKModelMacro: ExtensionMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        
        let declSyntax: DeclSyntax =
              """
              extension \(type.trimmed): CKModel {}
              """
        
        guard let extensionSyntax = declSyntax.as(ExtensionDeclSyntax.self) else { return [] }
        
        return [extensionSyntax]
    }
}
