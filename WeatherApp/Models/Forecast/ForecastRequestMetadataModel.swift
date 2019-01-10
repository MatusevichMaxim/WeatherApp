import Foundation

public struct ForecastRequestMetadataModel {
    
    public let cacheControl: String?
    public let apiRequestsCount: Int?
    public let responseTime: Float?
    
    public init(fromHTTPHeaderFields headerFields: [AnyHashable: Any]) {
        cacheControl = headerFields["Cache-Control"] as? String
        if let forecastAPICallsHeader = headerFields["x-forecast-api-calls"] as? String {
            apiRequestsCount = Int(forecastAPICallsHeader)
        } else {
            apiRequestsCount = nil
        }
        if var responseTimeHeader = headerFields["x-response-time"] as? String {
            // Remove "ms" units from the string
            responseTimeHeader = responseTimeHeader.trimmingCharacters(in: CharacterSet.letters)
            responseTime = Float(responseTimeHeader)
        } else {
            responseTime = nil
        }
    }
}
