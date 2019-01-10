import UIKit

public enum ForecastIOError: Error {
    
    /// Error due to invalid JSON.
    case invalidJSON(Data)
}
