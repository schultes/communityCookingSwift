class DatabaseService {
    static func isUsernameUnique(username: String, callback: @escaping (Bool) -> ()) {
        TPFirebaseFirestore.getDocuments(queryBuilder: TPFirebaseFirestoreQueryBuilder(collectionName: User.COLLECTION_NAME).whereEqualTo(field: "username", value: username)) {
            result, error in
            if let message = error {
                callback(true)
            }

            if let resultSet = result {
                callback(resultSet.isEmpty)
            }
        }
    }

    static func getUserById(documentId: String, callback: @escaping (User?, String?) -> ()) {
        let userCacheService = UserCacheService.getInstance()
        let cachedUser = userCacheService.getUserByDocumentId(documentId: documentId)
        if let user = cachedUser {
            callback(user, nil)
        } else {
            TPFirebaseFirestore.getDocument(collectionName: User.COLLECTION_NAME, documentId: documentId) {
                result, error in
                if let message = error {
                    callback(nil, message)
                }

                if let resultItem = result {
                    let userObject = User.toObject(documentId: resultItem.documentId, map: resultItem.data)
                    if let user = userObject {
                        userCacheService.self.setUser(user: user)
                        callback(userObject, nil)
                    } else {
                        callback(nil, "Bitte tragen Sie alle nötigen Informationen ein!")
                    }
                }
            }
        }
    }

    static func getUserByUsername(username: String, callback: @escaping (User?, String?) -> ()) {
        let userCacheService = UserCacheService.getInstance()
        let cachedUser = userCacheService.getUserByUsername(username: username)
        if let user = cachedUser {
            callback(user, nil)
        } else {
            TPFirebaseFirestore.getDocuments(queryBuilder: TPFirebaseFirestoreQueryBuilder(collectionName: User.COLLECTION_NAME).whereEqualTo(field: "username", value: username)) {
                result, error in
                if let message = error {
                    callback(nil, message)
                }

                if let resultItem = result {
                    if !resultItem.isEmpty {
                        let userObject = User.toObject(documentId: resultItem[0].documentId, map: resultItem[0].data)
                        if let user = userObject {
                            userCacheService.self.setUser(user: user)
                            callback(userObject, nil)
                        }
                    } else {
                        callback(nil, nil)
                    }
                } else {
                    callback(nil, "Bitte tragen Sie alle nötigen Informationen ein!")
                }
            }
        }
    }

    static func getUsersByUsernames(usernames: [String], callback: @escaping ([User]?, String?) -> ()) {
        let userCacheService = UserCacheService.getInstance()
        let cachedUsers = userCacheService.getUsersByUsernames(usernames: usernames)
        let unCachedUsernames = usernames.filter {
            username in
            cachedUsers.first {user in user.username == username} == nil
        }

        if unCachedUsernames.isEmpty {
            callback(cachedUsers, nil)
        } else {
            TPFirebaseFirestore.getDocuments(queryBuilder: TPFirebaseFirestoreQueryBuilder(collectionName: User.COLLECTION_NAME).whereIn(field: "username", value: unCachedUsernames)) {
                result, error in
                if let message = error {
                    callback(nil, message)
                }

                if let resultSet = result {
                    userCacheService.setUsers(users: resultSet.compactMap {element in User.toObject(documentId: element.documentId, map: element.data)})
                    callback(userCacheService.self.getUsersByUsernames(usernames: usernames), nil)
                }
            }
        }
    }

    static func getMyself(callback: @escaping (User?, String?) -> ()) {
        if let user = TPFirebaseAuthentication.getUser() {
            getUserById(documentId: user.uid, callback: callback)
        }
    }

    static func setUser(user: User, callback: @escaping (String?) -> ()) {
        TPFirebaseFirestore.setDocument(collectionName: User.COLLECTION_NAME, documentId: user.documentId, data: User.toMap(user: user)) {error in callback(error)}
    }

    static func setEvent(event: Event, callback: @escaping (String?) -> ()) {
        if event.documentId == nil {
            TPFirebaseFirestore.addDocument(collectionName: Event.COLLECTION_NAME, data: Event.toMap(event: event)) {document, error in callback(error)}
        } else {
            TPFirebaseFirestore.setDocument(collectionName: Event.COLLECTION_NAME, documentId: event.documentId!, data: Event.toMap(event: event), callback: callback)
        }
    }

    static func deleteEventById(documentId: String, callback: @escaping (String?) -> ()) {
        TPFirebaseFirestore.deleteDocument(collectionName: Event.COLLECTION_NAME, documentId: documentId, callback: callback)
    }

    static func getEventById(documentId: String, callback: @escaping (Event?, String?) -> ()) {
        TPFirebaseFirestore.getDocument(collectionName: Event.COLLECTION_NAME, documentId: documentId) {
            result, error in
            if let message = error {
                callback(nil, message)
            }

            if let resultItem = result {
                Event.toObject(documentId: resultItem.documentId, map: resultItem.data, callback: callback)
            }
        }
    }

    static func getEventsByRadius(user: User, userLocation: Location, callback: @escaping ([Event]?, String?) -> ()) {
        TPFirebaseFirestore.addCollectionSnapshotListener(queryBuilder: TPFirebaseFirestoreQueryBuilder(collectionName: Event.COLLECTION_NAME).whereEqualTo(field: "isPublic", value: true).orderBy(field: "timestamp", descending: true)) { result, error in
            
            if let message = error {
                callback(nil, message)
            }

            if let resultSet = result {
                var eventInRadiusList = [Event]()
                var tempEventList = [Event]()
                var finishedProcesses = 0
                
                if !resultSet.isEmpty {
                    resultSet.forEach { tpFirebaseFirestoreDocument in
                        Event.toObject(documentId: tpFirebaseFirestoreDocument.documentId, map: tpFirebaseFirestoreDocument.data) { result, _ in
                            if let event = result {
                                tempEventList.append(event)
                            }

                            finishedProcesses += 1
                            if finishedProcesses == resultSet.count {
                                tempEventList.forEach { event in
                                    if event.owner.documentId != user.documentId &&
                                        !event.requested.contains(where: { temp in return temp.documentId == user.documentId }) && !event.participating.contains(where: { temp in return temp.documentId == user.documentId }) && self.checkPreference(recipe: event.recipe, preference: user.preference) {
                                        if LocationService.calculateDistance(userLocation: userLocation, eventLocation: event.location) <= Double(user.radiusInKilometer) {
                                            eventInRadiusList.append(event)
                                        }
                                    }
                                }

                                callback(eventInRadiusList, nil)
                            }
                        }
                    }
                } else {
                    callback([], nil)
                }
            }
        }
    }

    static func getEventsParticipating(user: User, callback: @escaping ([Event]?, String?) -> ()) {
        TPFirebaseFirestore.addCollectionSnapshotListener(queryBuilder: TPFirebaseFirestoreQueryBuilder(collectionName: Event.COLLECTION_NAME).orderBy(field: "timestamp", descending: true)) {
            result, error in
            if let message = error {
                callback(nil, message)
            }

            if let resultSet = result {
                var tempEventList = [Event]()
                let filterdResultSet = resultSet.filter { ($0.data["owner"] as! String) == user.username || ($0.data["participating"] as! [String]).contains { $0 == user.username } }
                var finishedProcesses = 0
                
                if !filterdResultSet.isEmpty {
                    filterdResultSet.forEach { tpFirebaseFirestoreDocument in
                        Event.toObject(documentId: tpFirebaseFirestoreDocument.documentId, map: tpFirebaseFirestoreDocument.data) {
                            result, _ in
                            if let event = result {
                                tempEventList.append(event)
                            }

                            finishedProcesses += 1
                            if finishedProcesses == filterdResultSet.count {
                                callback(tempEventList, nil)
                            }
                        }
                    }
                } else {
                    callback([], nil)
                }
            }
        }
    }

    static func getEventsRequested(user: User, callback: @escaping ([Event]?, String?) -> ()) {
        TPFirebaseFirestore.addCollectionSnapshotListener(queryBuilder: TPFirebaseFirestoreQueryBuilder(collectionName: Event.COLLECTION_NAME).whereArrayContains(field: "requested", value: user.username).orderBy(field: "timestamp", descending: true)) {
            result, error in
            if let message = error {
                callback(nil, message)
            }

            if let resultSet = result {
                var tempEventList = [Event]()
                var finishedProcesses = 0
                if !resultSet.isEmpty {
                    resultSet.forEach {
                        tpFirebaseFirestoreDocument in
                        Event.toObject(documentId: tpFirebaseFirestoreDocument.documentId, map: tpFirebaseFirestoreDocument.data) {
                            result, _ in
                            if let event = result {
                                tempEventList.append(event)
                            }

                            finishedProcesses += 1
                            if finishedProcesses == resultSet.count {
                                callback(tempEventList, nil)
                            }
                        }
                    }
                } else {
                    callback([], nil)
                }
            }
        }
    }

    static func setRecipe(recipe: Recipe, callback: @escaping (String?) -> ()) {
        if recipe.documentId == nil {
            TPFirebaseFirestore.addDocument(collectionName: Recipe.COLLECTION_NAME, data: Recipe.toMap(recipe: recipe)) {
                document, error in
                callback(error)
            }
        } else {
            TPFirebaseFirestore.setDocument(collectionName: Recipe.COLLECTION_NAME, documentId: recipe.documentId!, data: Recipe.toMap(recipe: recipe), callback: callback)
        }
    }

    static func getRecipeById(documentId: String, callback: @escaping (Recipe?, String?) -> ()) {
        TPFirebaseFirestore.getDocument(collectionName: Recipe.COLLECTION_NAME, documentId: documentId) {
            result, error in
            if let message = error {
                callback(nil, message)
            }

            if let resultItem = result {
                Recipe.toObject(documentId: resultItem.documentId, map: resultItem.data, callback: callback)
            }
        }
    }

    static func getAllRecipes(callback: @escaping ([Recipe]?, String?) -> ()) {
        let query = TPFirebaseFirestoreQueryBuilder(collectionName: Recipe.COLLECTION_NAME).orderBy(field: "title", descending: false)
        TPFirebaseFirestore.addCollectionSnapshotListener(queryBuilder: query) {
            result, error in
            if let message = error {
                callback(nil, message)
            }

            if let resultSet = result {
                var tempRecipeList = [Recipe]()
                var finishedProcesses = 0
                if !resultSet.isEmpty {
                    resultSet.forEach {
                        tpFirebaseFirestoreDocument in
                        Recipe.toObject(documentId: tpFirebaseFirestoreDocument.documentId, map: tpFirebaseFirestoreDocument.data) {
                            result, _ in
                            if let recipe = result {
                                tempRecipeList.append(recipe)
                            }

                            finishedProcesses += 1
                            if finishedProcesses == resultSet.count {
                                callback(tempRecipeList, nil)
                            }
                        }
                    }
                } else {
                    callback([], nil)
                }
            }
        }
    }

    static func getRecipesFromUser(user: User, callback: @escaping ([Recipe]?, String?) -> ()) {
        getAllRecipes {
            result, error in
            if let recipes = result {
                callback(recipes.filter {
                    recipe in
                    recipe.owner.username == user.username
                }, nil)
            }

            if let message = error {
                callback(nil, message)
            }
        }
    }

    private static func checkPreference(recipe: Recipe, preference: RecipeType) -> Bool {
        return preference == RecipeType.NONE ? true : preference == RecipeType.VEGETARIAN && (recipe.type == RecipeType.VEGETARIAN || recipe.type == RecipeType.VEGAN) ? true : preference == RecipeType.VEGAN && recipe.type == RecipeType.VEGAN
    }

    static func sendMessage(message: Message, callback: @escaping (String?) -> ()) {
        if message.documentId == nil {
            TPFirebaseFirestore.addDocument(collectionName: Message.COLLECTION_NAME, data: Message.toMap(message: message)) {
                document, error in
                if let message = error {
                    callback(message)
                }
            }
        } else {
            TPFirebaseFirestore.setDocument(collectionName: Message.COLLECTION_NAME, documentId: message.documentId!, data: Message.toMap(message: message), callback: callback)
        }
    }

    static func getMessagesByContext(context: String, callback: @escaping ([Message]?, String?) -> ()) {
        TPFirebaseFirestore.addCollectionSnapshotListener(queryBuilder: TPFirebaseFirestoreQueryBuilder(collectionName: Message.COLLECTION_NAME).whereEqualTo(field: "context", value: context).orderBy(field: "timestamp", descending: true)) {
            result, error in
            if let message = error {
                callback(nil, message)
            }

            if let resultSet = result {
                var messageList = [Message]()
                var finishedProcesses = 0
                if !resultSet.isEmpty {
                    resultSet.forEach {
                        tpFirebaseFirestoreDocument in
                        Message.toObject(documentId: tpFirebaseFirestoreDocument.documentId, map: tpFirebaseFirestoreDocument.data) {
                            result, _ in
                            if let messageObject = result {
                                messageList.append(messageObject)
                            }

                            finishedProcesses += 1
                            if finishedProcesses == resultSet.count {
                                callback(messageList, nil)
                            }
                        }
                    }
                } else {
                    callback([], nil)
                }
            }
        }
    }
}
