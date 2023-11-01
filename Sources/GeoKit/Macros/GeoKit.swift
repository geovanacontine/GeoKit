// MACROS

@attached(extension, conformances: CKModel)
@attached(member, names: named(encodeToCKRecord), named(init), named(fetchDerivedProperties))
public macro CKModel() = #externalMacro(module: "GeoKitMacros", type: "CKModelMacro")

@attached(peer)
public macro CKDerivedProperty(query: String) = #externalMacro(module: "GeoKitMacros", type: "CKDerivedPropertyMacro")
