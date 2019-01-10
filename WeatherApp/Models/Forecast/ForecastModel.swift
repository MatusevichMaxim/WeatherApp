import Foundation

public struct ForecastModel {
    
    /// The requested latitude.
    public let latitude: Double
    
    /// The requested longitude.
    public let longitude: Double
    
    /// The IANA timezone name for the requested location (e.g. "America/New_York"). Rely on local user settings over this property.
    public let timezone: String
    
    /// Severe weather `Alert`s issued by a governmental weather authority for the requested location.
    public let alerts: [ForecastAlertModel]?
    
    /// Metadata for the request.
    public let flags: Flag?
    
    /// The current weather conditions at the requested location.
    public let currently: DataPoint?
    
    /// The minute-by-minute weather conditions at the requested location for the next hour aligned to the nearest minute.
    public let minutely: DataBlock?
    
    /// The hourly weather conditions at the requested location for the next two days aligned to the top of the hour.
    public let hourly: DataBlock?
    
    /// The daily weather conditions at the requested location for the next week aligned to midnight of the day.
    public let daily: DataBlock?
    
    /// Data fields associated with a `Forecast`.
    public enum Field: String {
        
        /// Current weather conditions.
        case currently = "currently"
        
        /// Minute-by-minute weather conditions for the next hour.
        case minutely = "minutely"
        
        /// Hour-by-hour weather conditions for the next two days by default but can be exte1nded to one week.
        case hourly = "hourly"
        
        /// Day-by-day weather conditions for the next week.
        case daily = "daily"
        
        /// Severe weather alerts.
        case alerts = "alerts"
        
        /// Miscellaneous metadata.
        case flags = "flags"
    }
    
    public init(fromJSON json: NSDictionary) {
        let response = json["response"] as! NSDictionary
        
        latitude = response["latitude"] as! Double
        longitude = response["longitude"] as! Double
        timezone = response["timezone"] as! String
        
        if let jsonCurrently = response["currently"] as? NSDictionary {
            currently = DataPoint(fromJSON: jsonCurrently)
        } else {
            currently = nil
        }
        if let jsonMinutely = response["minutely"] as? NSDictionary {
            minutely = DataBlock(fromJSON: jsonMinutely)
        } else {
            minutely = nil
        }
        if let jsonHourly = response["hourly"] as? NSDictionary {
            hourly = DataBlock(fromJSON: jsonHourly)
        } else {
            hourly = nil
        }
        if let jsonDaily = response["daily"] as? NSDictionary {
            daily = DataBlock(fromJSON: jsonDaily)
        } else {
            daily = nil
        }
        
        if let jsonAlerts = response["alerts"] as? [NSDictionary] {
            var tempAlerts = [ForecastAlertModel]()
            for jsonAlert in jsonAlerts {
                tempAlerts.append(ForecastAlertModel(fromJSON: jsonAlert))
            }
            alerts = tempAlerts
        } else {
            alerts = nil
        }
        
        if let jsonFlags = response["flags"] as? NSDictionary {
            flags = Flag(fromJSON: jsonFlags)
        } else {
            flags = nil
        }
    }
}
