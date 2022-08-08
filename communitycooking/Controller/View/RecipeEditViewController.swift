//
//  RecipeEditViewController.swift
//  communitycooking
//
//  Created by FMA2 on 04.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation
import SwiftUI

class RecipeEditViewController: ObservableObject, IRecipeEditViewController {
    
    private var modelController: RecipeEditModelController? = nil

    @Published var documentId: String? = nil
    @Published var timestamp = NSDate.init().timeIntervalSince1970
    @Published var title = ""
    @Published var description = ""
    
    @Published var imageId = ""
    
    @Published var isImageSelectionShowing = false
    @Published var imageSelected: UIImage? = nil
    
    @Published var recipePreference = RecipeType.NONE.rawValue
    
    @Published var portionSize: Int = 1
    @Published var durationInMinutes: Int = 1
    
    @Published var ingredients = [Ingredient]()
    @Published var steps = [String]()
    
    @Published var errorShowing = false
    @Published var errorMessage = ""
    
    init() {
        self.modelController = RecipeEditModelController(viewController: self)
    }
    
    func downloadData(recipeId: String?) {
        if recipeId != nil {
            self.modelController?.downloadData(recipeId: recipeId!)
        }
    }
    
    func setData(recipe: Recipe) {
        self.documentId = recipe.documentId
        
        self.timestamp = recipe.timestamp
        
        self.title = recipe.title
        self.description = recipe.description
        
        self.imageId = recipe.image
        
        self.recipePreference = recipe.type.rawValue

        self.portionSize = recipe.portionSize
        self.durationInMinutes = recipe.duration
        
        self.ingredients = recipe.ingredients
        self.steps = recipe.steps
    }
    
    func onSaveClicked() {
        
        self.title = self.title.trimming(spaces: .leadingAndTrailing)
        self.description = self.description.trimming(spaces: .leadingAndTrailing)
        
        if imageSelected != nil {
            
            imageId = imageId.isEmpty ? UUID().uuidString : imageId
                        
            FirebaseStorageSercice.uploadImageIntoStorage(imageId: imageId, image: imageSelected!) { isUploaded in
                if isUploaded {
    
                    if !self.title.isEmpty && !self.description.isEmpty && !self.recipePreference.isEmpty && self.portionSize > 0 && self.durationInMinutes > 0 && self.ingredients.count > 0 && self.steps.count > 0 {
                        self.modelController?.onSaveClicked(timestamp: self.timestamp, title: self.title, description: self.description, image: self.imageId, type: RecipeType(rawValue: self.recipePreference)!, steps: self.steps, ingredients: self.ingredients, portionSize: self.portionSize, duration: self.durationInMinutes, documentId: self.documentId)
                    } else {
                        self.errorMessage = "Bitte füllen Sie alle benötigten Informationen aus! Dazu zählen auch Zutaten und Bearbeitungsschritte!"
                        self.errorShowing = true
                    }
                    
                } else {
                    self.errorMessage = "Dieses Bild konnte leider nicht hochgeladen werden! Versuchen Sie es noch einmal!"
                    self.errorShowing = true
                }
            }
            
        }else{
            if !self.title.isEmpty && !self.description.isEmpty && !self.recipePreference.isEmpty && self.portionSize > 0 && self.durationInMinutes > 0 && self.ingredients.count > 0 && self.steps.count > 0 {
                self.modelController?.onSaveClicked(timestamp: self.timestamp, title: self.title, description: self.description, image: self.imageId, type: RecipeType(rawValue: self.recipePreference)!, steps: self.steps, ingredients: self.ingredients, portionSize: self.portionSize, duration: self.durationInMinutes, documentId: self.documentId)
            } else {
                self.errorMessage = "Bitte füllen Sie alle benötigten Informationen aus! Dazu zählen auch Zutaten und Bearbeitungsschritte!"
                self.errorShowing = true
            }
        }
    }
    
    func exitActivity() {
        NavigationStack.current?.pop()
    }
    
    func showErrorMessage(message: String) {
        self.errorMessage = message
        self.errorShowing = true
    }
}
