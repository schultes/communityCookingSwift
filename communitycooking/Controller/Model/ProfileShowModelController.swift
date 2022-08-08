//
//  ProfileShowModelController.swift
//  communitycooking
//
//  Created by FMA2 on 04.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

protocol IProfileShowViewController {
    func setData(meId: String, user: User, recipes: [Recipe])
    func showErrorMessage(message: String)
}

class ProfileShowModelController {
        
    private let viewController: IProfileShowViewController
    
    init(viewController: IProfileShowViewController) {
        self.viewController = viewController
    }
    
    func downloadData(userId: String) {
        if let meId = TPFirebaseAuthentication.getUser()?.uid {
            DatabaseService.getUserById(documentId: userId) { result, error in
                if let user = result {
                    DatabaseService.getRecipesFromUser(user: user) { result, error in
                        if let recipes = result {
                            self.viewController.setData(meId: meId, user: user, recipes: recipes)
                        }
                        
                        if let message = error {
                            self.viewController.showErrorMessage(message: message)
                        }
                    }
                }
                
                if let message = error {
                    self.viewController.showErrorMessage(message: message)
                }
            }
        }
    }
}
