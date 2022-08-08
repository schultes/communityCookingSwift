//
//  ContentView.swift
//  communitycooking
//
//  Created by FMA2 on 06.11.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var navigationStack: NavigationStack
    
    var body: some View {
        NavigationStackView(navigationStack: navigationStack) {
            LoginAcitivty()
                .onAppear {
                    if TPFirebaseAuthentication.isSignedIn() {
                        DatabaseService.getMyself() { user, error in
                            if user != nil {
                                self.navigationStack.push(MainActivity())
                            } else {
                                self.navigationStack.push(ProfileEditActivity())
                            }
                        }
                    }
                }
        }
    }
}
