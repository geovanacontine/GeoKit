enum InitMacroError: Error, CustomStringConvertible {
    case invalidType
    
    var description: String {
        switch self {
        case .invalidType: "@Init can be attached only to classes or structs."
        }
    }
}
