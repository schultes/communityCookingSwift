//
//  ProfileShowActivity.swift
//  communitycooking
//
//  Created by FMA2 on 27.11.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI

struct ProfileShowActivity: View {
    
    @EnvironmentObject private var navigationStack: NavigationStack
    
    @ObservedObject private var viewController = ProfileShowViewController()
    
    let userId: String
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            if self.viewController.isLoaded() {
                
                ScrollView {
                    
                    Group {
                    
                        Spacer().frame(height: 56)
                        
                        ZStack(alignment: .top) {
                            
                            ZStack(alignment: .topLeading) {
                                Image("baseline_arrow_back_black_24pt")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(Color.white)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                            .onTapGesture {
                                self.navigationStack.pop()
                            }
                            .zIndex(1)
                            
                            AsyncStorageImage(reference: self.viewController.user!.image, placeholderImage: PlaceholderImage.USER)
                                .frame(width: 128, height: 128, alignment: .center)
                                .border(Color.white, width: 4)
                                .background(
                                    Rectangle()
                                        .fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 4)
                                )
                                .zIndex(2)
                            
                            VStack {
                                
                                Spacer().frame(height: 72)
                                
                                VStack(alignment: .leading, spacing: 20) {
                                    
                                    Spacer().frame(height: 16)
                                    
                                    Group {
                                    
                                        Text(self.viewController.user!.username)
                                            .modifier(CommunityCookingTheme.typography.h3)
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                            .padding(.top, 4)
                                                                            
                                        Text("Hallo ich bin \(self.viewController.user!.forename)!")
                                            .modifier(CommunityCookingTheme.typography.h1)
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                        
                                        VStack(spacing: 8) {
                                                                                
                                            Text("Über mich")
                                                .modifier(CommunityCookingTheme.typography.h3)
                                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                                                                
                                            Text(self.viewController.user!.description)
                                                .modifier(CommunityCookingTheme.typography.body1)
                                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                            
                                        }
                                        
                                        HStack {
                                                                                
                                            Text("Präferenz")
                                                .modifier(CommunityCookingTheme.typography.h3)
                                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                                                                
                                            Text(self.viewController.user!.preference.rawValue)
                                                .foregroundColor(CommunityCookingTheme.colors.PRIMARY)
                                                .font(Font.system(size: 12).weight(.bold))
                                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                                            
                                        }
                                    }
                                    .padding(.horizontal, 24)
                                    
                                    VStack(spacing: 8) {
                                                                        
                                        Text("Meine Rezepte")
                                            .modifier(CommunityCookingTheme.typography.h3)
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal, 24)
                                        
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 8) {
                                                ForEach(self.viewController.recipes!, id: \.self) { element in
                                                    
                                                    VStack(alignment: .center, spacing: 4) {
                                                        
                                                        AsyncStorageImage(reference: element.image, placeholderImage: PlaceholderImage.RECIPE)
                                                            .frame(width: 128, height: 128, alignment: .center)
                                                        
                                                        Text(element.title)
                                                            .foregroundColor(CommunityCookingTheme.colors.SECONDARY)
                                                            .font(Font.system(size: 10).weight(.bold))
                                                            .lineLimit(1)
                                                            .padding(.horizontal, 4)
                                                            .padding(.vertical, 8)
                                                            .padding(.bottom, 4)
                                                        
                                                    }
                                                    .border(Color.white, width: 4)
                                                    .frame(width: 132)
                                                    .background(
                                                        Rectangle()
                                                            .fill(Color.white)
                                                            .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 2)
                                                    )
                                                    .onTapGesture {
                                                        self.navigationStack.push(RecipeShowActivity(recipeId: element.documentId!))
                                                    }
                                                }
                                            }
                                            .padding(.horizontal, 24)
                                            .padding(.vertical, 4)
                                        }
                                    }
                                    
                                    Text("© Community Cooking App 2022")
                                        .modifier(CommunityCookingTheme.typography.body2)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                    
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding(.vertical, 24)
                                .background(
                                    Rectangle()
                                        .fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 4)
                                )
                            }
                        }
                        
                        Spacer().frame(height: 56)
                        
                    }
                    .padding(.horizontal, 24)
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            
                if self.viewController.meId == self.viewController.user!.documentId {
                    Button(action: onEditClicked, label: {
                        Image("baseline_edit_black_24pt")
                            .resizable()
                            .frame(width: 32, height: 32, alignment: .center)
                            .foregroundColor(Color.white)
                    })
                    .background(
                        Circle()
                            .fill(CommunityCookingTheme.colors.PRIMARY)
                            .frame(width: 64, height: 64)
                            .shadow(color: Color.black.opacity(0.2), radius: 1, x: 2, y: 2)
                    )
                    .offset(x: -32, y: -32)
                }
            } else {
                Text("Loading ...")
                    .font(Font.system(size: 12).weight(.bold))
                    .foregroundColor(Color.white)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .onTapGesture {
                        self.navigationStack.pop()
                    }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(false)
        .background(CommunityCookingTheme.colors.SECONDARY)
        .edgesIgnoringSafeArea(.all)
        .actionSheet(isPresented: self.$viewController.errorShowing) {
            ActionSheet(title: Text("Error"), message: Text(viewController.errorMessage), buttons: [.cancel(Text("OK"))])
        }
        .onAppear() {
            self.viewController.downloadData(userId: self.userId)
        }
    }
    
    func onEditClicked() {
        self.navigationStack.push(ProfileEditActivity())
    }
}
