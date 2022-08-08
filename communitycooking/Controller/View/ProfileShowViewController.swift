//
//  ProfileShowViewController.swift
//  communitycooking
//
//  Created by FMA2 on 04.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

class ProfileShowViewController: ObservableObject, IProfileShowViewController {
    
    private var modelController: ProfileShowModelController? = nil
        
    @Published var meId: String?
    @Published var user: User?
    @Published var recipes: [Recipe]?
        
    @Published var errorShowing = false
    @Published var errorMessage = ""
    
    init() {
        self.modelController = ProfileShowModelController(viewController: self)
    }
    
    func downloadData(userId: String) {
        self.modelController?.downloadData(userId: userId)
    }
    
    func isLoaded() -> Bool {
        return meId != nil && user != nil && recipes != nil
    }
    
    func setData(meId: String, user: User, recipes: [Recipe]) {
        self.meId = meId
        self.user = user
        self.recipes = recipes
    }
    
    func showErrorMessage(message: String) {
        self.errorMessage = message
        self.errorShowing = true
    }
}
