//
//  RecipeShowModelController.swift
//  communitycooking
//
//  Created by FMA2 on 04.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

protocol IRecipeShowViewController {
    func setData(userId: String, recipe: Recipe)
    func showErrorMessage(message: String)
}

class RecipeShowModelController {
    private let viewController: IRecipeShowViewController
    init(viewController: IRecipeShowViewController) {
        self.viewController = viewController
    }

    func downloadData(recipeId: String) {
        if let userId = TPFirebaseAuthentication.getUser()?.uid {
            DatabaseService.getRecipeById(documentId: recipeId) {
                result, error in
                if let recipe = result {
                    self.viewController.setData(userId: userId, recipe: recipe)
                }

                if let message = error {
                    self.viewController.showErrorMessage(message: message)
                }
            }
        }
    }
}
