import UIKit

struct DimensionsManager {
    static func convertToCelsius(fahrenheit: Int) -> Int {
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }
    
    static func convertToCelsius(kelvin: Double) -> Int {
        return Int(round(kelvin - 273.15))
    }
}
