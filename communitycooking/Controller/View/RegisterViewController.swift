//
//  RegisterViewController.swift
//  communitycooking
//
//  Created by FMA2 on 04.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

class RegisterViewController: ObservableObject, IRegisterViewController {
    
    private var modelController: RegisterModelController? = nil

    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var passwordRepeat = ""

    @Published var errorShowing = false
    @Published var errorMessage = ""

    init() {
        self.modelController = RegisterModelController(viewController: self)
    }

    func onRegisterClicked() {
        
        self.username = self.username.trimming(spaces: .all)
        self.email = self.email.trimming(spaces: .leadingAndTrailing)
        self.password = self.password.trimming(spaces: .leadingAndTrailing)
        self.passwordRepeat = self.passwordRepeat.trimming(spaces: .leadingAndTrailing)
        
        if !username.isEmpty && ValidationService.isEmail(email: email) && !email.isEmpty && !password.isEmpty && !passwordRepeat.isEmpty && password == passwordRepeat{
            self.modelController?.onRegisterClicked(email: email, password: password, username: username)
        } else {
            self.showErrorMessage(message: "Bitte füllen Sie alle benötigten Informationen aus!")
        }
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
