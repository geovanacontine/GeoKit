import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import GeoKitMacros

let testableMacros: [String: Macro.Type] = [
    "Init": InitMacro.self,
    "CKModel": CKModelMacro.self,
    "CKDerivedProperty": CKDerivedPropertyMacro.self,
    "ReducerFeature": ReducerFeatureMacro.self,
    "ReducerStore": ReducerStoreMacro.self,
    "Logger": LoggerMacro.self
]
