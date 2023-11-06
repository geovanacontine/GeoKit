import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import GeoKitMacros

let testableMacros: [String: Macro.Type] = [
    "Init": InitMacro.self,
    "CKModel": CKModelMacro.self,
    "CKDerivedProperty": CKDerivedPropertyMacro.self,
    "ReduxFeature": ReduxFeatureMacro.self,
    "Redux": ReduxMacro.self,
    "Logger": LoggerMacro.self
]
