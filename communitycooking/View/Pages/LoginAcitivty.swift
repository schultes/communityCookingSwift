//
//  LoginAcitivty.swift
//  communitycooking
//
//  Created by FMA2 on 27.11.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI

struct LoginAcitivty: View {
    
    @EnvironmentObject private var navigationStack: NavigationStack
    
    @ObservedObject private var viewController = LoginViewController()
        
    var body: some View {
        ZStack(alignment: .center) {
            
            Group {
                
                VStack(spacing: 20) {
                    
                    Image("logo")
                        .resizable()
                        .frame(width: 160, height: 160, alignment: .center)
                    
                    TextFieldEmailValidation(text: self.$viewController.email, label: "Emailadresse")
                    TextFieldPasswordValidation(text: self.$viewController.password, label: "Passwort")
                    
                    HStack {
                        Text("Kein Konto?")
                            .modifier(CommunityCookingTheme.typography.body1)
                            .onTapGesture {
                                self.onRedirectToRegisterActivityClicked()
                            }
                    }
                    
                    Spacer().frame(height: 16)
                    
                    Button(action: onLoginClicked) {
                        Text("Anmelden".uppercased())
                            .font(Font.system(size: 14))
                            .foregroundColor(Color.white)
                    }
                    .frame(width: 160, height: 40)
                    .background(
                        Rectangle()
                            .fill(CommunityCookingTheme.colors.PRIMARY)
                            .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 2)
                    )
                    
                    Text("© Community Cooking App 2022")
                        .modifier(CommunityCookingTheme.typography.body2)
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .padding(.all, 24)
                .background(
                    Rectangle()
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 4)
                )
                
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .padding(.vertical, 96)
            .padding(.horizontal, 24)
            .edgesIgnoringSafeArea(.all)
            
        }
        .navigationBarTitle("")
        .navigationBarHidden(false)
        .background(CommunityCookingTheme.colors.SECONDARY)
        .edgesIgnoringSafeArea(.all)
        .actionSheet(isPresented: self.$viewController.errorShowing) {
            ActionSheet(title: Text("Error"), message: Text(viewController.errorMessage), buttons: [.cancel(Text("OK"))])
        }
        .KeyboardAwarePadding(offsetY: -36)
    }
    
    func onLoginClicked() {
        viewController.onLoginClicked()
    }
    
    func onRedirectToRegisterActivityClicked() {
        navigationStack.pop()
        navigationStack.push(RegisterAcitivty())
    }
}
