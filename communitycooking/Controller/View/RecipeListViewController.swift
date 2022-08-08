//
//  RecipeListViewController.swift
//  communitycooking
//
//  Created by FMA2 on 04.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

class RecipeListViewController: ObservableObject, IRecipeListViewController {
    
    private var modelController: RecipeListModelController? = nil
        
    @Published var needle: String = "" {
        didSet {
            self.fitlerRecipes()
        }
    }
    
    @Published var isVegetarian: Bool = false {
        didSet {
            self.fitlerRecipes()
        }
    }
    @Published var isVegan: Bool = false {
        didSet {
            self.fitlerRecipes()
        }
    }
    
    @Published var recipes = [Recipe]()
    @Published var filteredRecipes = [Recipe]()
        
    @Published var errorShowing = false
    @Published var errorMessage = ""
    
    init() {
        self.modelController = RecipeListModelController(viewController: self)
    }
    
    func downloadData() {
        self.modelController?.downloadData()
    }
        
    func fitlerRecipes() {
        self.modelController?.fitlerRecipes(recipes: self.recipes, needle: self.needle, isVegetarian: self.isVegetarian, isVegan: self.isVegan)
    }
    
    func setRecipes(recipes: [Recipe]) {
        self.recipes = recipes
        self.fitlerRecipes()
    }
    
    func setFilteredRecipes(recipes: [Recipe]) {
        self.filteredRecipes = recipes
    }
    
    func showErrorMessage(message: String) {
        self.errorMessage = message
        self.errorShowing = true
    }
}
