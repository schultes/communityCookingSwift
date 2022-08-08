//
//  TranslationService.swift
//  communitycooking
//
//  Created by FMA2 on 31.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

class TranslationService {
    
    static func translate(translatable: String) -> String {
     
        let dictionary = [
            "VEGAN": "Vegan",
            "VEGETARIAN": "Vegetarisch",
            "NONE": "Keine"
        ]
        
        return dictionary[translatable]!
    }
    
    static func ingredientType(ingredientName: String) -> String {
        return ingredientName == IngredientUnit.PINCH.rawValue ? "Prise" : ingredientName
    }
}
