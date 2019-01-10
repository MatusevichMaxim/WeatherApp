import Foundation

public struct Flag {
    
    public let darkSkyUnavailable: Bool?
    public let darkSkyStations: [String]?
    public let dataPointStations: [String]?
    public let isdStations: [String]?
    public let lampStations: [String]?
    public let metarStations: [String]?
    public let metnoLicense: Bool?
    public let sources: [String]
    public let units: Units
    
    public init(fromJSON json: NSDictionary) {
        darkSkyUnavailable = json["darksky-unavailable"] as? Bool
        darkSkyStations = json["darksky-stations"] as? [String]
        dataPointStations = json["datapoint-stations"] as? [String]
        isdStations = json["isd-stations"] as? [String]
        lampStations = json["lamp-stations"] as? [String]
        metarStations = json["metar-stations"] as? [String]
        metnoLicense = json["metno-license"] as? Bool
        sources = json["sources"] as! [String]
        units = Units(rawValue: json["units"] as! String)!
    }
}
