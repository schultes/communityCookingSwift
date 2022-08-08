struct Message: Hashable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.context == rhs.context && lhs.timestamp == rhs.timestamp && lhs.user == rhs.user && lhs.text == rhs.text && lhs.documentId! == rhs.documentId!
    }

    let context: String
    let timestamp: Double
    let user: User
    let text: String
    let documentId: String?
    
    static let COLLECTION_NAME = "message"
    static func toMap(message: Message) -> [String: Any] {
        return ["context": message.context, "timestamp": message.timestamp, "user": message.user.username, "text": message.text]
    }

    static func toObject(documentId: String, map: [String: Any], callback: @escaping (Message?, String?) -> ()) {
        if map["context"] == nil || map["timestamp"] == nil || map["user"] == nil || map["text"] == nil {
            callback(nil, "Fatal Error")
        } else {
            DatabaseService.getUserByUsername(username: map["user"]! as! String) { result, error in
                if let message = error {
                    callback(nil, message)
                }

                if let user = result {
                    let message = Message(
                        context: map["context"]! as! String,
                        timestamp: map["timestamp"]! as! Double,
                        user: user,
                        text: map["text"]! as! String,
                        documentId: documentId
                    )
                    callback(message, nil)
                }
            }
        }
    }
}

