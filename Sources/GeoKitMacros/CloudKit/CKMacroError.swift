enum CKMacroError: Error, CustomStringConvertible {
    case notStructType
    case invalidModelName
    case missingIdField
    
    var description: String {
        switch self {
        case .notStructType: "@CKModel can be attached only to structs."
        case .invalidModelName: "@CKModel requires a valid struct name."
        case .missingIdField: "@CKModel requires a field called id."
        }
    }
}
