import os

public class GeoLogger {
    private var subsystem: String = ""
    public static let shared = GeoLogger()
    
    private init() {}
    
    public func setupSubsystem(named name: String) {
        subsystem = name
    }
    
    public func error(_ error: Error, logger: Logger) {
        let errorString = error as CustomStringConvertible
        let errorMessage = errorString.description
        logger.error("\(errorMessage)")
    }
    
    public func makeLogger(forCategory category: String) -> Logger {
        Logger(subsystem: subsystem, category: category)
    }
}
