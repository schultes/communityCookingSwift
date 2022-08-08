//
//  RecipeListModelController.swift
//  communitycooking
//
//  Created by FMA2 on 04.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

protocol IRecipeListViewController {
    func setRecipes(recipes: [Recipe])
    func setFilteredRecipes(recipes: [Recipe])
    func showErrorMessage(message: String)
}

class RecipeListModelController {
        
    private let viewController: IRecipeListViewController
    
    init(viewController: IRecipeListViewController) {
        self.viewController = viewController
    }
    
    func downloadData() {
        DatabaseService.getAllRecipes() { result, error in
            if let recipes = result {
                self.viewController.setRecipes(recipes: recipes)
            }

            if let message = error {
                self.viewController.showErrorMessage(message: message)
            }
        }
    }
    
    func fitlerRecipes(recipes: [Recipe], needle: String, isVegetarian: Bool, isVegan: Bool) {
        
        if !recipes.isEmpty {
            
            var usernameQuery = ""
            var titleQuery = ""
            
            if needle.starts(with: "@") {
                usernameQuery = needle
            } else {
                titleQuery = needle
            }
                
            let filteredRecipes = recipes.filter { recipe in
                !usernameQuery.isEmpty ? recipe.owner.username.lowercased().contains(needle.lowercased()) : true
            } .filter { recipe in
                !titleQuery.isEmpty ? recipe.title.lowercased().contains(needle.lowercased()) : true
            } .filter { recipe in
                switch recipe.type {
                    case RecipeType.VEGAN:
                        return isVegan || (!isVegan && !isVegetarian)
                    case RecipeType.VEGETARIAN:
                        return isVegetarian || (!isVegan && !isVegetarian)
                    default:
                        return (!isVegan && !isVegetarian)
                }
            }
            
            self.viewController.setFilteredRecipes(recipes: filteredRecipes)
        }
    }
}
