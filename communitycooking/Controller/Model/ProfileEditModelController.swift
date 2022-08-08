//
//  ProfileEditModelController.swift
//  communitycooking
//
//  Created by FMA2 on 04.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

protocol IProfileEditViewController {
    func redirectToMainActivity()
    func exitActivity()
    func showErrorMessage(message: String)
}

class ProfileEditModelController {
    private let viewController: IProfileEditViewController
    init(viewController: IProfileEditViewController) {
        self.viewController = viewController
    }

    func onSaveClicked(username: String, firstname: String, lastname: String, email: String, description: String, image: String, preference: RecipeType, radius: Int, create: Bool) {
        if let user = TPFirebaseAuthentication.getUser() {
            let newUser = User(documentId: user.uid, username: create ? "@\(username)" : username, forename: firstname, lastname: lastname, description: description, image: image, preference: preference, radiusInKilometer: radius)
            if create {
                DatabaseService.isUsernameUnique(username: newUser.username) { isUnique in
                    if isUnique {
                        DatabaseService.setUser(user: newUser) {
                            error in
                            if let message = error {
                                self.viewController.showErrorMessage(message: message)
                            } else if create {
                                self.viewController.redirectToMainActivity()
                            } else {
                                self.viewController.exitActivity()
                            }
                        }
                    }
                }
            } else {
                DatabaseService.setUser(user: newUser) { error in
                    if let message = error {
                        self.viewController.showErrorMessage(message: message)
                    }else if create {
                        self.viewController.redirectToMainActivity()
                    } else {
                        self.viewController.exitActivity()
                    }
                }
            }

            if email != user.email {
                TPFirebaseAuthentication.updateCurrentUserEmail(email: email) { error in
                    if let message = error {
                        self.viewController.showErrorMessage(message: message)
                    }
                }
            }
        }
    }
}

