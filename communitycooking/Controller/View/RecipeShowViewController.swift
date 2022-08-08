//
//  RecipeShowViewController.swift
//  communitycooking
//
//  Created by FMA2 on 04.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

class RecipeShowViewController: ObservableObject, IRecipeShowViewController {
    
    private var modelController: RecipeShowModelController? = nil
        
    @Published var userId: String?
    @Published var recipe: Recipe?
        
    @Published var errorShowing = false
    @Published var errorMessage = ""
    
    init() {
        self.modelController = RecipeShowModelController(viewController: self)
    }
        
    func downloadData(recipeId: String) {
        self.modelController?.downloadData(recipeId: recipeId)
    }
    
    func setData(userId: String, recipe: Recipe) {
        self.userId = userId
        self.recipe = recipe
    }
    
    func isLoaded() -> Bool {
        return userId != nil && recipe != nil
    }
    
    func showErrorMessage(message: String) {
        self.errorMessage = message
        self.errorShowing = true
    }
}
