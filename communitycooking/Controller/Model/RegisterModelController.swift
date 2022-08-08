//
//  RegisterModelController.swift
//  communitycooking
//
//  Created by FMA2 on 04.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

protocol IRegisterViewController {
    func redirectToProfileEditActivity()
    func showErrorMessage(message: String)
}

class RegisterModelController {
    private let viewController: IRegisterViewController
    init(viewController: IRegisterViewController) {
        self.viewController = viewController
    }

    func onRegisterClicked(email: String, password: String, username: String) {
        DatabaseService.isUsernameUnique(username: "@\(username)") {
            unique in
            if unique {
                AuthenticationService.signUp(email: email, password: password, username: username) { result, error in
                    if result != nil {
                        self.viewController.redirectToProfileEditActivity()
                    }

                    if let message = error {
                        self.viewController.showErrorMessage(message: message)
                    }
                }
            } else {
                self.viewController.showErrorMessage(message: "Benutzername ist bereits vergeben!")
            }
        }
    }
}
