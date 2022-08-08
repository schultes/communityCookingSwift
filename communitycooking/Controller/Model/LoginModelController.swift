//
//  LoginModelController.swift
//  communitycooking
//
//  Created by FMA2 on 04.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

protocol ILoginViewController {
    func redirectToMainActivity()
    func redirectToProfileEditActivity()
    func showErrorMessage(message: String)
}

class LoginModelController {
    private let viewController: ILoginViewController
    init(viewController: ILoginViewController) {
        self.viewController = viewController
    }

    func onLoginClicked(email: String, password: String) {
        AuthenticationService.signIn(email: email, password: password) { result, error in
            
            if result != nil {
                DatabaseService.getMyself() { result, error in
                    if result != nil {
                        self.viewController.redirectToMainActivity()
                    } else if TPFirebaseAuthentication.isSignedIn() {
                        self.viewController.redirectToProfileEditActivity()
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
