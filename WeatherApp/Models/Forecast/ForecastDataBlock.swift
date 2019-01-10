import Foundation

public struct DataBlock {
    
    public let summary: String?
    public let icon: Icon?
    public let data: [DataPoint]
    
    public init(fromJSON json: NSDictionary) {
        summary = json["summary"] as? String
        if let jsonIcon = json["icon"] as? String {
            icon = Icon(rawValue: jsonIcon)
        } else {
            icon = nil
        }
        
        let jsonData = json["data"] as! [NSDictionary]
        var tempData = [DataPoint]()
        for jsonDataPoint in jsonData {
            tempData.append(DataPoint(fromJSON: jsonDataPoint))
        }
        data = tempData
    }
}
