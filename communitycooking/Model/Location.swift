struct Location: Hashable {
    
    let timestamp: Double
    let latitude: Double
    let longitude: Double
    
    static func toMap(locationContent: Location) -> [String: Any] {
        return ["timestamp": locationContent.timestamp, "latitude": locationContent.latitude, "longitude": locationContent.longitude]
    }

    static func toObject(map: [String: Any]) -> Location? {
        return map["timestamp"] == nil || map["latitude"] == nil || map["longitude"] == nil ? nil : Location(timestamp: map["timestamp"]! as! Double, latitude: map["latitude"]! as! Double, longitude: map["longitude"]! as! Double)
    }
}
