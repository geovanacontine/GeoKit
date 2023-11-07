// MACROS

@attached(extension, conformances: CKModel)
@attached(member, names: named(encodeToCKRecord), named(init), named(fetchDerivedProperties))
public macro CKModel() = #externalMacro(module: "GeoKitMacros", type: "CKModelMacro")

@attached(peer)
public macro CKDerivedProperty(query: String) = #externalMacro(module: "GeoKitMacros", type: "CKDerivedPropertyMacro")

@attached(member, names: named(reduce), named(init), named(effects), named(reducer))
public macro ReducerFeature() = #externalMacro(module: "GeoKitMacros", type: "ReducerFeatureMacro")

@attached(member, names: named(run), named(state), named(State), named(Action))
public macro ReducerStore(features: String...) = #externalMacro(module: "GeoKitMacros", type: "ReducerStoreMacro")

@attached(peer, names: suffixed(WithLogger))
public macro Logger(_ info: String, success: String, error: String, feature: String) = #externalMacro(module: "GeoKitMacros", type: "LoggerMacro")
