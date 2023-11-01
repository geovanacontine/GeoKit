// MACROS

@attached(extension, conformances: CKModel)
@attached(member, names: named(encodeToCKRecord), named(init), named(fetchDerivedProperties))
public macro CKModel() = #externalMacro(module: "GeoKitMacros", type: "CKModelMacro")

@attached(peer)
public macro CKDerivedProperty(query: String) = #externalMacro(module: "GeoKitMacros", type: "CKDerivedPropertyMacro")

@attached(member, names: named(run))
public macro ReduxFeature() = #externalMacro(module: "GeoKitMacros", type: "ReduxFeatureMacro")

@attached(peer, names: named(AppState))
@attached(member, names: named(run))
public macro Redux() = #externalMacro(module: "GeoKitMacros", type: "ReduxMacro")
