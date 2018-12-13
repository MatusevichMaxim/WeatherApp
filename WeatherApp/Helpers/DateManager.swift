import UIKit

class DateManager: NSObject {
    static func getDate(adjHours: Int = 0) -> String {
        let currentDate = Date()
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .hour, value: adjHours, to: currentDate)!
        let targetDateString = "\(date.dayMedium) \(date.monthMedium.lowercased()) \(date.yearMedium)  ·  \(date.hourMedium):\(date.minuteMedium)"

        return targetDateString
    }
}

extension Date {
    var yearMedium: String  { return Formatter.yearMedium.string(from: self) }
    var monthMedium: String  { return Formatter.monthMedium.string(from: self) }
    var dayMedium: String  { return Formatter.dayMedium.string(from: self) }
    var hourMedium: String  { return Formatter.hourMedium.string(from: self) }
    var minuteMedium: String  { return Formatter.minuteMedium.string(from: self) }
}

extension Formatter {
    static let yearMedium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    static let monthMedium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL"
        return formatter
    }()
    static let dayMedium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()
    static let hourMedium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter
    }()
    static let minuteMedium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return formatter
    }()
}
