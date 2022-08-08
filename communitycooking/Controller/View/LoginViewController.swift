//
//  LoginViewController.swift
//  communitycooking
//
//  Created by FMA2 on 04.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

class LoginViewController: ObservableObject, ILoginViewController {
    
    private var modelController: LoginModelController? = nil
    
    @Published var email = ""
    @Published var password = ""
    
    @Published var errorShowing = false
    @Published var errorMessage = ""
    
    init() {
        self.modelController = LoginModelController(viewController: self)
    }
    
    func onLoginClicked() {
        
        self.email = self.email.trimming(spaces: .leadingAndTrailing)
        self.password = self.password.trimming(spaces: .leadingAndTrailing)
        
        if ValidationService.isEmail(email: email) && !email.isEmpty && !password.isEmpty {
            self.modelController?.onLoginClicked(email: email, password: password)
        } else {
            self.showErrorMessage(message: "Bitte füllen Sie alle benötigten Informationen aus!")
        }
    }
    
    func redirectToMainActivity() {
        NavigationStack.current?.pop()
        NavigationStack.current?.push(MainActivity())
    }
    
    func redirectToProfileEditActivity() {
        NavigationStack.current?.pop()
        NavigationStack.current?.push(ProfileEditActivity())
    }
    
    func showErrorMessage(message: String) {
        self.errorMessage = message
        self.errorShowing = true
    }
}
