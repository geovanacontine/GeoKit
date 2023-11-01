import CloudKit

extension CKDatabase {
    func fetchAll(withQuery query: CKQuery) async -> [CKRecord] {
        var records: [CKRecord] = []
        var currentCursor: CKQueryOperation.Cursor?
        
        let result = await fetch(withQuery: query)
        records += result.records
        currentCursor = result.cursor
        
        while let cursor = currentCursor {
            let result = await fetch(withCursor: cursor)
            records += result.records
            currentCursor = result.cursor
        }
        
        return records
    }
    
    func fetch(withQuery query: CKQuery) async -> (records: [CKRecord], cursor: CKQueryOperation.Cursor?) {
        await withCheckedContinuation { continuation in
            fetch(withQuery: query) { result in
                switch result {
                case .success(let result):
                    let records = result.matchResults.compactMap({ try? $0.1.get() })
                    continuation.resume(returning: (records, result.queryCursor))
                case .failure:
                    continuation.resume(returning: ([], nil))
                }
            }
        }
    }
    
    func fetch(withCursor cursor: CKQueryOperation.Cursor) async -> (records: [CKRecord], cursor: CKQueryOperation.Cursor?) {
        await withCheckedContinuation { continuation in
            fetch(withCursor: cursor) { result in
                switch result {
                case .success(let result):
                    let records = result.matchResults.compactMap({ try? $0.1.get() })
                    continuation.resume(returning: (records, result.queryCursor))
                case .failure:
                    continuation.resume(returning: ([], nil))
                }
            }
        }
    }
}
