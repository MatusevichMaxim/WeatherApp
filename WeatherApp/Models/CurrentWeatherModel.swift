import UIKit
import Foundation

struct CurrentWeatherModel {
    let temperature: Double
    let pressure: Double
    //let icon: UIImage
}

extension CurrentWeatherModel : JSONDecodable {
    init?(JSON: [String : AnyObject]) {
        guard let temperature = JSON["temp"] as? Double,
        let pressure = JSON["pressure"] as? Double else {
            return nil
        }
        
        //let icon = WeatherIconManager(rawValue: iconString).image
        
        self.temperature = temperature
        self.pressure = pressure
        //self.icon = icon
    }
}

extension CurrentWeatherModel {
    var temperatureString: String {
        let temperatureInCelsius = DimensionsManager.convertToCelsius(kelvin: temperature)
        return "\(temperatureInCelsius)"
    }
}
