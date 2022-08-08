//
//  RecipeEditModelController.swift
//  communitycooking
//
//  Created by FMA2 on 04.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

protocol IRecipeEditViewController {
    func setData(recipe: Recipe)
    func exitActivity()
    func showErrorMessage(message: String)
}

class RecipeEditModelController {
    private let viewController: IRecipeEditViewController
    init(viewController: IRecipeEditViewController) {
        self.viewController = viewController
    }

    func downloadData(recipeId: String) {
        DatabaseService.getRecipeById(documentId: recipeId) {
            result, error in
            if let recipe = result {
                self.viewController.setData(recipe: recipe)
            }

            if let message = error {
                self.viewController.showErrorMessage(message: message)
            }
        }
    }

    func onSaveClicked(timestamp: Double, title: String, description: String, image: String, type: RecipeType, steps: [String], ingredients: [Ingredient], portionSize: Int, duration: Int, documentId: String?) {
        DatabaseService.getMyself {
            result, error in
            if let user = result {
                let recipe = Recipe(timestamp: timestamp, owner: user, title: title, description: description, image: image, type: type, steps: steps, ingredients: ingredients, portionSize: portionSize, duration: duration, documentId: documentId)
                DatabaseService.setRecipe(recipe: recipe) {
                    error in
                    if let message = error {
                        self.viewController.showErrorMessage(message: message)
                    } else {
                        self.viewController.exitActivity()
                    }
                }
            }

            if let message = error {
                self.viewController.showErrorMessage(message: message)
            }
        }
    }
}
