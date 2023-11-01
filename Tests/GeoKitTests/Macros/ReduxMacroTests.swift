import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import GeoKitMacros

final class ReduxMacroTests: XCTestCase {
    
    func testReduxMacro() throws {
        assertMacroExpansion(
            #"""
            
            @Redux
            enum Action {
                case feature1
                case feature2
            }
            
            """#,
            expandedSource: #"""
            enum Action {
                case feature1
                case feature2

                static func run(_ action: Action, forState state: AppState = AppState.shared) async {
                    switch action {
                    case .feature1(let feature1Action):
                        await feature1Action.run(usingMapper: .init(state: state))
                    case .feature2(let feature2Action):
                        await feature2Action.run(usingMapper: .init(state: state))
                    }
                }
            }
            
            @Observable
            class AppState {

                var feature1 = Feature1State()
                var feature2 = Feature2State()

                static let shared = AppState()
                private init() {
                }
            }
            """#,
            macros: testableMacros
        )
    }
    
    func testReduxFeatureMacro() throws {
        assertMacroExpansion(
            #"""
            
            @ReduxFeature
            enum ExploreAction {
                case listAll
                case listFiltered
            }
            
            """#,
            expandedSource: #"""
            enum ExploreAction {
                case listAll
                case listFiltered

                func run(usingMapper mapper: ExploreMapper) async {
                    switch self {
                    case .listAll:
                        await mapper.listAll()
                    case .listFiltered:
                        await mapper.listFiltered()
                    }
                }
            }
            """#,
            macros: testableMacros
        )
    }
}
