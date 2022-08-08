//
//  RecipeListActivity.swift
//  communitycooking
//
//  Created by FMA2 on 27.11.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI

struct RecipeListActivity: View {
    
    @EnvironmentObject private var navigationStack: NavigationStack
    
    @ObservedObject private var viewController = RecipeListViewController()
    
    var resultViewController: EventEditViewController? = nil
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            ScrollView {
                
                Group {
                    
                    Spacer().frame(height: 56)
                    
                    VStack(spacing: 16) {
                        
                        VStack(alignment: .center, spacing: 16) {
                            HStack {
                                Group {
                                    Image("baseline_arrow_back_black_24pt")
                                        .resizable()
                                        .frame(width: 24, height: 24, alignment: .center)
                                        .foregroundColor(CommunityCookingTheme.colors.SECONDARY)
                                }
                                .frame(width: 64, height: 40)
                                .onTapGesture {
                                    self.navigationStack.pop()
                                }
                                
                                Divider()
                                    .offset(x: -8)
                                
                                TextField("Suche nach ...", text: self.$viewController.needle)
                                    .font(Font.system(size: 12))
                                    .padding(.top, 2)
                                    .frame(height: 40, alignment: .center)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                            )
                            
                            HStack {
                                Text("VEGETARISCH")
                                    .font(Font.system(size: 12))
                                    .foregroundColor(self.viewController.isVegetarian ? Color.white : CommunityCookingTheme.colors.SECONDARY)
                                    .padding(.horizontal, 24)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(self.viewController.isVegetarian ? CommunityCookingTheme.colors.PRIMARY : Color.white)
                                            .frame(height: 24, alignment: .center)
                                    ).onTapGesture {
                                        self.viewController.isVegetarian.toggle()
                                    }

                                Text("VEGAN")
                                    .font(Font.system(size: 12))
                                    .foregroundColor(self.viewController.isVegan ? Color.white : CommunityCookingTheme.colors.SECONDARY)
                                    .padding(.horizontal, 24)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(self.viewController.isVegan ? CommunityCookingTheme.colors.PRIMARY : Color.white)
                                            .frame(height: 24, alignment: .center)
                                    ).onTapGesture {
                                        self.viewController.isVegan.toggle()
                                    }
                            }
                        }
                        
                        if self.resultViewController != nil {
                            
                            Spacer()
                            
                            Text("Tippe auf das Rezept, das Du Deinem Event hinzufügen möchtest!")
                                .font(Font.system(size: 12).weight(.bold))
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.center)
                                .frame(width: 256)
                            
                        }
                        
                        Spacer()
                        
                        ForEach(self.viewController.filteredRecipes, id: \.self) { recipes in
                            RecipeListElement(recipe: recipes, resultViewController: self.resultViewController)
                        }
                    }
                    
                    Spacer().frame(height: 16)
        
                    Text("© Community Cooking App 2022")
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 10))
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    
                    Spacer().frame(height: 56)
                    
                }
                .padding(.horizontal, 24)
            
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            
            Button(action: onAddClicked, label: {
                Image("baseline_add_black_24pt")
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
        .navigationBarTitle("")
        .navigationBarHidden(false)
        .background(CommunityCookingTheme.colors.SECONDARY)
        .edgesIgnoringSafeArea(.all)
        .actionSheet(isPresented: self.$viewController.errorShowing) {
            ActionSheet(title: Text("Error"), message: Text(viewController.errorMessage), buttons: [.cancel(Text("OK"))])
        }
        .onAppear() {
            self.viewController.downloadData()
        }
    }
    
    func onAddClicked() {
        self.navigationStack.push(RecipeEditActivity())
    }
}
