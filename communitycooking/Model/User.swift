struct User: Hashable {
    
    let documentId: String
    let username: String
    let forename: String
    let lastname: String
    let description: String
    let image: String
    let preference: RecipeType
    let radiusInKilometer: Int
    var fullname: String {
        "\(forename) \(lastname)"
    }

    static let COLLECTION_NAME = "user"
    static func toMap(user: User) -> [String: Any] {
        return ["username": user.username, "forename": user.forename, "lastname": user.lastname, "description": user.description, "image": user.image, "preference": user.preference.rawValue, "radiusInKilometer": user.radiusInKilometer]
    }

    static func toObject(documentId: String, map: [String: Any]) -> User? {
        return map["username"] == nil || map["forename"] == nil || map["lastname"] == nil || map["description"] == nil || map["image"] == nil || map["preference"] == nil || map["radiusInKilometer"] == nil ? nil : User(documentId: documentId, username: map["username"]! as! String, forename: map["forename"]! as! String, lastname: map["lastname"]! as! String, description: map["description"]! as! String, image: map["image"]! as! String, preference: RecipeType(rawValue: map["preference"]! as! String)!, radiusInKilometer: map["radiusInKilometer"]! as! Int)
    }
}

