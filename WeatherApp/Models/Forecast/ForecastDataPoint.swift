import Foundation

public struct DataPoint {
    
    public let time: Date
    public let summary: String?
    public let icon: Icon?
    public let sunriseTime: Date?
    public let sunsetTime: Date?
    public let moonPhase: Double?
    public let nearestStormDistance: Double?
    public let nearestStormBearing: Double?
    public let precipitationIntensity: Double?
    public let precipitationIntensityMax: Double?
    public let precipitationIntensityMaxTime: Date?
    public let precipitationProbability: Double?
    public let precipitationType: Precipitation?
    public let precipitationAccumulation: Double?
    public let temperature: Double?
    public let temperatureLow: Double?
    public let temperatureLowTime: Date?
    public let temperatureHigh: Double?
    public let temperatureHighTime: Date?
    public let apparentTemperature: Double?
    public let apparentTemperatureLow: Double?
    public let apparentTemperatureLowTime: Date?
    public let apparentTemperatureHigh: Double?
    public let apparentTemperatureHighTime: Date?
    public let dewPoint: Double?
    public let windGust: Double?
    public let windSpeed: Double?
    public let windBearing: Double?
    public let cloudCover: Double?
    public let humidity: Double?
    public let pressure: Double?
    public let visibility: Double?
    public let ozone: Double?
    public let uvIndex: Double?
    public let uvIndexTime: Date?
    
    public init(fromJSON json: NSDictionary) {
        time = Date(timeIntervalSince1970: json["time"] as! Double)
        summary = json["summary"] as? String
        if let jsonIcon = json["icon"] as? String {
            icon = Icon(rawValue: jsonIcon)
        } else {
            icon = nil
        }
        if let jsonSunriseTime = json["sunriseTime"] as? Double {
            sunriseTime = Date(timeIntervalSince1970: jsonSunriseTime)
        } else {
            sunriseTime = nil
        }
        if let jsonSunsetTime = json["sunsetTime"] as? Double {
            sunsetTime = Date(timeIntervalSince1970: jsonSunsetTime)
        } else {
            sunsetTime = nil
        }
        moonPhase = json["moonPhase"] as? Double
        nearestStormDistance = json["nearestStormDistance"] as? Double
        nearestStormBearing = json["nearestStormBearing"] as? Double
        precipitationIntensity = json["precipIntensity"] as? Double
        precipitationIntensityMax = json["precipIntensityMax"] as? Double
        if let jsonPrecipitationIntensityMaxTime = json["precipIntensityMaxTime"] as? Double {
            precipitationIntensityMaxTime = Date(timeIntervalSince1970: jsonPrecipitationIntensityMaxTime)
        } else {
            precipitationIntensityMaxTime = nil
        }
        precipitationProbability = json["precipProbability"] as? Double
        if let jsonPrecipitationType = json["precipType"] as? String {
            precipitationType = Precipitation(rawValue: jsonPrecipitationType)
        } else {
            precipitationType = nil
        }
        precipitationAccumulation = json["precipAccumulation"] as? Double
        temperature = json["temperature"] as? Double
        temperatureLow = json["temperatureLow"] as? Double
        if let jsonTemperatureLowTime = json["temperatureLowTime"] as? Double {
            temperatureLowTime = Date(timeIntervalSince1970: jsonTemperatureLowTime)
        } else {
            temperatureLowTime = nil
        }
        temperatureHigh = json["temperatureHigh"] as? Double
        if let jsonTemperatureHighTime = json["temperatureHighTime"] as? Double {
            temperatureHighTime = Date(timeIntervalSince1970: jsonTemperatureHighTime)
        } else {
            temperatureHighTime = nil
        }
        apparentTemperature = json["apparentTemperature"] as? Double
        apparentTemperatureLow = json["apparentTemperatureLow"] as? Double
        if let jsonApparentTemperatureLowTime = json["apparentTemperatureLowTime"] as? Double {
            apparentTemperatureLowTime = Date(timeIntervalSince1970: jsonApparentTemperatureLowTime)
        } else {
            apparentTemperatureLowTime = nil
        }
        apparentTemperatureHigh = json["apparentTemperatureHigh"] as? Double
        if let jsonApparentTemperatureHighTime = json["apparentTemperatureHighTime"] as? Double {
            apparentTemperatureHighTime = Date(timeIntervalSince1970: jsonApparentTemperatureHighTime)
        } else {
            apparentTemperatureHighTime = nil
        }
        dewPoint = json["dewPoint"] as? Double
        windGust = json["windGust"] as? Double
        windSpeed = json["windSpeed"] as? Double
        windBearing = json["windBearing"] as? Double
        cloudCover = json["cloudCover"] as? Double
        humidity = json["humidity"] as? Double
        pressure = json["pressure"] as? Double
        visibility = json["visibility"] as? Double
        ozone = json["ozone"] as? Double
        uvIndex = json["uvIndex"] as? Double
        if let jsonUVIndexTime = json["uvIndexTime"] as? Double {
            uvIndexTime = Date(timeIntervalSince1970: jsonUVIndexTime)
        } else {
            uvIndexTime = nil
        }
    }
}
