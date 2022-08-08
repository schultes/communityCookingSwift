struct Recipe: Hashable{
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.timestamp == rhs.timestamp && lhs.owner == rhs.owner && lhs.title == rhs.title && lhs.description == rhs.description && lhs.image == rhs.image && lhs.type == rhs.type && lhs.steps == rhs.steps && lhs.ingredients == rhs.ingredients && lhs.portionSize == rhs.portionSize && lhs.duration == rhs.duration && lhs.documentId! == rhs.documentId!
    }
    
    let timestamp: Double
    let owner: User
    let title: String
    let description: String
    let image: String
    let type: RecipeType
    let steps: [String]
    let ingredients: [Ingredient]
    let portionSize: Int
    let duration: Int
    let documentId: String?
    
    static let COLLECTION_NAME = "recipe"
    static func toMap(recipe: Recipe) -> [String: Any] {
        return ["timestamp": recipe.timestamp, "owner": recipe.owner.username, "title": recipe.title, "description": recipe.description, "image": recipe.image, "type": recipe.type.rawValue, "steps": recipe.steps, "ingredients": recipe.ingredients.map {
            ingredient in
            Ingredient.toMap(ingredient: ingredient)
        }, "portionSize": recipe.portionSize, "duration": recipe.duration]
    }

    static func toObject(documentId: String, map: [String: Any], callback: @escaping (Recipe?, String?) -> ()) {
        if map["timestamp"] == nil || map["owner"] == nil || map["title"] == nil || map["description"] == nil || map["image"] == nil || map["type"] == nil || map["steps"] == nil || map["ingredients"] == nil || map["portionSize"] == nil || map["duration"] == nil {
            callback(nil, "Fatal Error")
        } else {
            var ingredientList = [Ingredient]()
            let ingredientArray = map["ingredients"] as! [[String: Any]]
            ingredientArray.forEach {
                ingredientMap in
                if let ingredientObject = Ingredient.toObject(map: ingredientMap) {
                    ingredientList.append(ingredientObject)
                }
            }

            DatabaseService.getUserByUsername(username: map["owner"]! as! String) {
                result, error in
                if let message = error {
                    callback(nil, message)
                }

                if let user = result {
                    let recipe = Recipe(
                        timestamp: map["timestamp"]! as! Double,
                        owner: user,
                        title: map["title"]! as! String,
                        description: map["description"]! as! String,
                        image: map["image"]! as! String,
                        type: RecipeType(rawValue: map["type"]! as! String)!,
                        steps: map["steps"] as! [String],
                        ingredients: ingredientList,
                        portionSize: map["portionSize"]! as! Int,
                        duration: map["duration"]! as! Int,
                        documentId: documentId
                    )
                    callback(recipe, nil)
                }
            }
        }
    }
}
