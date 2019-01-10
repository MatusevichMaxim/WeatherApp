import Foundation

class ForecastClient: NSObject {
    private let session = URLSession.shared
    private static let serverURL = "http://192.168.100.3:5001/api/forecast"
    
    open var units: Units?
    open var language: Language?
    
    public init(apiKey key: String) {
    }
    
    open func getForecast(latitude lat: Double, longitude lon: Double, extendHourly: Bool = false, excludeFields: [ForecastModel.Field] = [], completion: @escaping (Result<ForecastModel>) -> Void) {
        let url = buildForecastURL(latitude: lat, longitude: lon, time: nil, extendHourly: extendHourly, excludeFields: excludeFields)
        getForecast(url: url, completionHandler: completion)
    }
    
    private func getForecast(url: URL, completionHandler: @escaping (Result<ForecastModel>) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        let task = self.session.dataTask(with: urlRequest, completionHandler: { (data: Data?, response, err: Error?) -> Void in
            if let err = err {
                completionHandler(Result.failure(err))
            } else {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    if let json = jsonObject as? NSDictionary, let httpURLResponse = response as? HTTPURLResponse {
                        let forecast = ForecastModel(fromJSON: json)
                        let requestMetadata = ForecastRequestMetadataModel(fromHTTPHeaderFields: httpURLResponse.allHeaderFields)
                        completionHandler(Result.success(forecast, requestMetadata))
                    }
                } catch _ {
                    let invalidJSONError = ForecastIOError.invalidJSON(data!)
                    completionHandler(Result.failure(invalidJSONError))
                }
            }
        })
        task.resume()
    }
    
    private func buildForecastURL(latitude lat: Double, longitude lon: Double, time: Date?, extendHourly: Bool, excludeFields: [ForecastModel.Field]) -> URL {
        //  Build URL path
        var urlString = ForecastClient.serverURL
        if let time = time {
            let timeString = String(format: "%.0f", time.timeIntervalSince1970)
            urlString.append(",\(timeString)")
        }
        
        //  Build URL query parameters
        var urlBuilder = URLComponents(string: urlString)!
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "lat", value: String(format: "%f", lat)))
        queryItems.append(URLQueryItem(name: "lon", value: String(format: "%f", lon)))
        
        if let units = self.units {
            queryItems.append(URLQueryItem(name: "units", value: units.rawValue))
        }
        if let language = self.language {
            queryItems.append(URLQueryItem(name: "lang", value: language.rawValue))
        }
        if extendHourly {
            queryItems.append(URLQueryItem(name: "extend", value: "hourly"))
        }
        if !excludeFields.isEmpty {
            var excludeFieldsString = ""
            for field in excludeFields {
                if excludeFieldsString != "" {
                    excludeFieldsString.append(",")
                }
                excludeFieldsString.append("\(field.rawValue)")
            }
            queryItems.append(URLQueryItem(name: "exclude", value: excludeFieldsString))
        }
        urlBuilder.queryItems = queryItems
        
        return urlBuilder.url!
    }
}
