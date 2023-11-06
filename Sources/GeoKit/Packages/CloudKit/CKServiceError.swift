enum CKServiceError: Error, CustomStringConvertible {
    case decodingError
    case fetchError(query: CKQuery)
}

extension CKServiceError {
    var description: String {
        switch self {
        case .decodingError: "Failed to decoded CloudKit response."
        case .fetchError(let query): "Failed to fetch recordType [\(query.recordType)] using predicate [\(query.predicate)]."
        }
    }
}
