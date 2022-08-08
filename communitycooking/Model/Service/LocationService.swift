import Foundation

class LocationService {
    static func calculateDistance(userLocation: Location, eventLocation: Location) -> Double {
        //calculates distance between 2 sets of coordinates based on the haversine formula
        let earthRadius = 6371
        let differenceLatitude = degreeToRadius(deg: eventLocation.latitude - userLocation.latitude)
        let differenceLongitude = degreeToRadius(deg: eventLocation.longitude - userLocation.longitude)
        let a = sin(differenceLatitude / 2) * sin(differenceLatitude / 2) + cos(degreeToRadius(deg: userLocation.latitude)) * cos(degreeToRadius(deg: eventLocation.latitude)) * sin(differenceLongitude / 2) * sin(differenceLongitude / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        return Double(earthRadius) * c
    }

    static private func degreeToRadius(deg: Double) -> Double {
        return deg * (Double.pi / 180)
    }
}
