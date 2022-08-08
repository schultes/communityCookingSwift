//
//  ProfileEditViewController.swift
//  communitycooking
//
//  Created by FMA2 on 04.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI
import Foundation

class ProfileEditViewController: ObservableObject, IProfileEditViewController {
    
    private var modelController: ProfileEditModelController? = nil
    
    @Published var create = false
    
    @Published var forename = ""
    @Published var lastname = ""
    @Published var description = ""
    
    @Published var imageId = ""
    
    @Published var isImageSelectionShowing = false
    @Published var imageSelected: UIImage? = nil
    
    @Published var radiusInKilometer = 15.0
    @Published var recipePreference = RecipeType.NONE.rawValue
    
    @Published var username = ""
    @Published var email = ""
    
    @Published var resetShowing = false
    @Published var errorShowing = false
    @Published var errorMessage = ""
    
    init() {
        self.modelController = ProfileEditModelController(viewController: self)
        
        DatabaseService.getMyself() { result, error in
                        
            if let user = result {
                self.create = false
                
                self.username = user.username
                self.forename = user.forename
                self.lastname = user.lastname
                self.description = user.description
                
                self.imageId = user.image
                
                self.radiusInKilometer = Double(user.radiusInKilometer)
                self.recipePreference = user.preference.rawValue
                
            } else {
                self.create = true
                
                if let authenticationUser = TPFirebaseAuthentication.getUser() {
                    self.username = authenticationUser.displayName!
                }
            }
            
            if let message = error {
                self.showErrorMessage(message: message)
            }
        }
        
        if let authenticationUser = TPFirebaseAuthentication.getUser() {
            email = authenticationUser.email
        }
    }
    
    func onSaveClicked() {
        
        self.username = self.username.trimming(spaces: .all)
        self.forename = self.forename.trimming(spaces: .leadingAndTrailing)
        self.lastname = self.lastname.trimming(spaces: .leadingAndTrailing)
        self.email = self.email.trimming(spaces: .leadingAndTrailing)
        self.description = self.description.trimming(spaces: .leadingAndTrailing)
        
        if imageSelected != nil {
            
            imageId = imageId.isEmpty ? UUID().uuidString : imageId
            
            FirebaseStorageSercice.uploadImageIntoStorage(imageId: imageId, image: imageSelected!) { isUploaded in
                if isUploaded {
                    if !self.username.isEmpty && !self.forename.isEmpty && !self.lastname.isEmpty && ValidationService.isEmail(email: self.email) && !self.email.isEmpty && !self.description.isEmpty {
                        self.modelController?.onSaveClicked(username: self.username, firstname: self.forename, lastname: self.lastname, email: self.email, description: self.description, image: self.imageId, preference: RecipeType(rawValue: self.recipePreference)!, radius: Int(self.radiusInKilometer), create: self.create)
                    } else {
                        self.errorMessage = "Bitte füllen Sie alle benötigten Informationen aus!"
                        self.errorShowing = true
                    }
                } else {
                    self.errorMessage = "Dieses Bild konnte leider nicht hochgeladen werden! Versuchen Sie es noch einmal!"
                    self.errorShowing = true
                }
            }
            
        }else{
            if !username.isEmpty && !forename.isEmpty && !lastname.isEmpty && ValidationService.isEmail(email: email) && !email.isEmpty && !description.isEmpty {
                modelController?.onSaveClicked(username: username, firstname: forename, lastname: lastname, email: email, description: description, image: imageId, preference: RecipeType(rawValue: recipePreference)!, radius: Int(radiusInKilometer), create: create)
            } else {
                self.errorMessage = "Bitte füllen Sie alle benötigten Informationen aus!"
                self.errorShowing = true
            }
        }
    }
    
    func onPasswordChange() {
        TPFirebaseAuthentication.sendEmailVerification() { error in
            if let message = error {
                self.showErrorMessage(message: message)
            } else {
                self.resetShowing = true
            }
        }
    }
    
    func redirectToMainActivity() {
        NavigationStack.current?.pop()
        NavigationStack.current?.push(MainActivity())
    }
    
    func exitActivity() {
        NavigationStack.current?.pop()
    }
    
    func showErrorMessage(message: String) {
        self.errorMessage = message
        self.errorShowing = true
    }
}
