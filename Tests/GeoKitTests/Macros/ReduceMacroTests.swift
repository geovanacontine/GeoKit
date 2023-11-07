import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import GeoKitMacros

final class ReduceMacroTests: XCTestCase {
    
    func testReducerStoreMacro() throws {
        assertMacroExpansion(
            #"""
            
            @Observable
            @ReducerStore(features: "Explore", "Rating")
            class Store {}
            
            """#,
            expandedSource: #"""
            @Observable
            class Store {

                struct State {
                     var explore = ExploreFeature.State()
                     var rating = RatingFeature.State()
                }

                enum Action {
                     case explore(ExploreFeature.Action)
                case rating(RatingFeature.Action)
                }

                var state = State()

                func run(_ action: Action) async {
                    switch action {
                     case .explore(let subAction): await ExploreFeature().reduce(state: &state.explore, action: subAction)
                case .rating(let subAction): await RatingFeature().reduce(state: &state.rating, action: subAction)
                    }
                }}
            """#,
            macros: testableMacros
        )
    }
    
    func testReduceFeatureMacro() throws {
        assertMacroExpansion(
            #"""
            
            @ReducerFeature
            struct ExploreFeature {
                struct State {
                    var allCoffees: [Coffee] = []
                }
            
                enum Action {
                    case listAllCoffees(id: String)
                }
            }
            
            """#,
            expandedSource: #"""
            struct ExploreFeature {
                struct State {
                    var allCoffees: [Coffee] = []
                }
            
                enum Action {
                    case listAllCoffees(id: String)
                }

                private let effects: ExploreFeatureEffects
                private let reducer: ExploreFeatureReducer

                init() {
                    effects = .init()
                    reducer = .init(effects: effects)
                }

                func reduce(state: inout State, action: Action) async {
                    switch action {
                    case .listAllCoffees(let id): await reducer.listAllCoffees(id: id, state: &state)
                    }
                }
            }
            """#,
            macros: testableMacros
        )
    }
}
