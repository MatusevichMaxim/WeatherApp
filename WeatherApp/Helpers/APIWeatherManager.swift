import UIKit
import Foundation

struct Coordinates {
    let latitude: Double
    let longitude: Double
}

enum ForecastType : FinalURLPoint {
    case Current(apiKey: String, coordinates: Coordinates)
    
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org")!
    }
    
    var path: String {
        switch self {
            case .Current(let apiKey, let coordinates):
                return "/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(apiKey)"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        return URLRequest(url: url!)
    }
}

final class APIWeatherManager : APIManager {
    let sessionConfiguration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    } ()
    
    let apiKey: String
    
    init(sessionConfiguration: URLSessionConfiguration, apiKey: String) {
        self.sessionConfiguration = sessionConfiguration
        self.apiKey = apiKey
    }
    
    convenience init(apiKey: String) {
        self.init(sessionConfiguration: URLSessionConfiguration.default, apiKey: apiKey)
    }
    
    func fetchCurrentWeatherWith(coordinates: Coordinates, completionHandler: @escaping (APIResult<CurrentWeatherModel>) -> Void) {
        let request = ForecastType.Current(apiKey: self.apiKey, coordinates: coordinates).request
        
        fetch(request: request, parse: { (json) -> CurrentWeatherModel? in
            if let dictionary = json["main"] as? [String: AnyObject] {
                return CurrentWeatherModel(JSON: dictionary)
            } else {
                return nil
            }
        }, completionHandler: completionHandler)
    }
}
