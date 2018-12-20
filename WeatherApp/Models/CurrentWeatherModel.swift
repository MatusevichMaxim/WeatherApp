import UIKit
import Foundation

struct CurrentWeatherModel {
    let temperature: Double
    let pressure: Double
    let icon: UIImage
}

extension CurrentWeatherModel : JSONDecodable {
    init?(JSON: [String : AnyObject]) {
        guard let temperature = JSON["temperature"] as? Double,
            let pressure = JSON["pressure"] as? Double,
            let iconString = JSON["icon"] as? String else {
                return nil
        }
        
        let icon = WeatherIconManager(rawValue: iconString).image
        
        self.temperature = temperature
        self.pressure = pressure
        self.icon = icon
    }
}
