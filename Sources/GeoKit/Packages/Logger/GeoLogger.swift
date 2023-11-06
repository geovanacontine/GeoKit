@_exported import os

public class GeoLogger {
    public private(set) var subsystem: String = ""
    public static let shared = GeoLogger()
    
    private init() {}
    
    public lazy var view = Logger(subsystem: subsystem, category: "View")
    
    public func setupSubsystem(named name: String) {
        subsystem = name
    }
}
