struct Event: Hashable {
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.timestamp == rhs.timestamp && lhs.owner == rhs.owner && lhs.location == rhs.location && lhs.isPublic == rhs.isPublic && lhs.title == rhs.title && lhs.description == rhs.description && lhs.recipe == rhs.recipe && lhs.requested == rhs.requested && lhs.participating == rhs.participating && lhs.documentId! == rhs.documentId!
    }
    
    let timestamp: Double
    let owner: User
    let location: Location
    let isPublic: Bool
    let title: String
    let description: String
    let recipe: Recipe
    let requested: [User]
    let participating: [User]
    let documentId: String?
    
    static let COLLECTION_NAME = "event"
    static func toMap(event: Event) -> [String: Any] {
        return ["timestamp": event.timestamp, "owner": event.owner.username, "location": Location.toMap(locationContent: event.location), "isPublic": event.isPublic, "title": event.title, "description": event.description, "recipe": event.recipe.documentId!, "requested": event.requested.map {
            user in
            user.username
        }, "participating": event.participating.map {
            user in
            user.username
        }]
    }

    static func toObject(documentId: String, map: [String: Any], callback: @escaping (Event?, String?) -> ()) {
        if map["timestamp"] == nil || map["owner"] == nil || map["location"] == nil || map["isPublic"] == nil || map["title"] == nil || map["description"] == nil || map["recipe"] == nil || map["requested"] == nil || map["participating"] == nil {
            callback(nil, "Fatal Error")
        } else {
            let locationObject = Location.toObject(map: map["location"] as! [String: Any])
            if let location = locationObject {
                let ownerUsername = map["owner"]! as! String
                let requestedUsernames = map["requested"]! as! [String]
                let participatingUsernames = map["participating"]! as! [String]
                
                var necessaryUsernames = [String]()
                necessaryUsernames += [ownerUsername]
                necessaryUsernames += requestedUsernames
                necessaryUsernames += participatingUsernames
                DatabaseService.getUsersByUsernames(usernames: necessaryUsernames) {
                    result, error in
                    if let message = error {
                        callback(nil, message)
                    }

                    if let tempUserList = result {
                        let ownerUserObject = tempUserList.first {user in ownerUsername == user.username}
                        let requestedUserObjects = tempUserList.filter {user in requestedUsernames.contains(user.username)}
                        let participatingUserObjects = tempUserList.filter {user in participatingUsernames.contains(user.username)}
                        
                        if let owner = ownerUserObject {
                            let recipeDocumentId = map["recipe"]! as! String
                            TPFirebaseFirestore.getDocument(collectionName: Recipe.COLLECTION_NAME, documentId: recipeDocumentId) {
                                result, error in
                                if let message = error {
                                    callback(nil, message)
                                }

                                if let resultItem = result {
                                    Recipe.toObject(documentId: resultItem.documentId, map: resultItem.data) {
                                        result, error in
                                        if let message = error {
                                            callback(nil, message)
                                        }

                                        if let recipe = result {
                                            let event = Event(
                                                timestamp: map["timestamp"]! as! Double,
                                                owner: owner,
                                                location: location,
                                                isPublic: map["isPublic"]! as! Bool,
                                                title: map["title"]! as! String,
                                                description: map["description"]! as! String,
                                                recipe: recipe,
                                                requested: requestedUserObjects,
                                                participating: participatingUserObjects,
                                                documentId: documentId
                                            )
                                            callback(event, nil)
                                        }
                                    }
                                }
                            }
                        } else {
                            callback(nil, "Owner Error")
                        }
                    }
                }
            } else {
                callback(nil, "Location Error")
            }
        }
    }
}
