import Foundation

public struct ForecastAlertModel {
    
    public let title: String
    public let time: Date
    public let expires: Date?
    public let description: String
    public let uri: URL
    public let regions: [String]
    public let severity: Severity
    public enum Severity: String {
        case advisory = "advisory"
        case watch = "watch"
        case warning = "warning"
    }
    
    public init(fromJSON json: NSDictionary) {
        title = json["title"] as! String
        if let jsonExpires = json["expires"] as? Double {
            expires = Date(timeIntervalSince1970: jsonExpires)
        } else {
            expires = nil
        }
        time = Date(timeIntervalSince1970: json["time"] as! Double)
        uri = URL(string: json["uri"] as! String)!
        description = json["description"] as! String
        regions = json["regions"] as! [String]
        severity = Severity(rawValue: json["severity"] as! String)!
    }
}

