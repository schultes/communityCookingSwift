struct Ingredient: Hashable {
    
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.name == rhs.name && lhs.amount == rhs.amount && lhs.unit == rhs.unit
    }
    
    let name: String
    let amount: Double
    let unit: IngredientUnit
    static func toMap(ingredient: Ingredient) -> [String: Any] {
        return ["name": ingredient.name, "amount": ingredient.amount, "unit": ingredient.unit.rawValue]
    }

    static func toObject(map: [String: Any]) -> Ingredient? {
        return map["name"] == nil || map["amount"] == nil || map["unit"] == nil ? nil : Ingredient(name: map["name"]! as! String, amount: map["amount"]! as! Double, unit: IngredientUnit(rawValue: map["unit"]! as! String)!)
    }
}
