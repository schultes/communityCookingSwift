//
//  RecipeShowActivity.swift
//  communitycooking
//
//  Created by FMA2 on 27.11.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI

struct RecipeShowActivity: View {
    
    @EnvironmentObject private var navigationStack: NavigationStack
    
    @ObservedObject private var viewController = RecipeShowViewController()
    
    let recipeId: String
    
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
                            
                            AsyncStorageImage(reference: self.viewController.recipe!.image, placeholderImage: PlaceholderImage.RECIPE)
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
                                    
                                    Spacer().frame(height: 24)
                                    
                                    VStack(alignment: .center, spacing: 4) {
                                        Text(self.viewController.recipe!.title)
                                            .modifier(CommunityCookingTheme.typography.h1)
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                            .multilineTextAlignment(.center)
                                        
                                        Text(self.format(timestamp: self.viewController.recipe!.timestamp))
                                            .modifier(CommunityCookingTheme.typography.h3)
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                    }
                                    
                                    HStack(alignment: .center) {
                                        HStack(alignment: .center, spacing: 8) {
                                            Text("\(String(self.viewController.recipe!.duration)) Minuten")
                                                .font(Font.system(size: 10).weight(.bold))
                                                .foregroundColor(Color.white)
                                            
                                            Image("baseline_access_time_filled_black_24pt")
                                                .resizable()
                                                .frame(width: 14, height: 14, alignment: .center)
                                                .foregroundColor(Color.white)
                                        }
                                        .padding(.all, 4)
                                        .padding(.trailing, 2)
                                        .padding(.leading, 4)
                                        .background(
                                            CommunityCookingTheme.colors.SECONDARY
                                                .frame(height: 24)
                                                .cornerRadius(12, corners: [.topRight, .bottomRight])
                                        )
                                        
                                        Spacer()
                                        
                                        HStack(alignment: .center, spacing: 8) {
                                            Image("baseline_person_black_24pt")
                                                .resizable()
                                                .frame(width: 14, height: 14, alignment: .center)
                                                .foregroundColor(Color.white)
                                            
                                            Text(self.viewController.recipe!.owner.fullname)
                                                .font(Font.system(size: 10).weight(.bold))
                                                .foregroundColor(Color.white)
                                        }
                                        .padding(.all, 4)
                                        .padding(.leading, 2)
                                        .padding(.trailing, 4)
                                        .background(
                                            CommunityCookingTheme.colors.PRIMARY
                                                .frame(height: 24)
                                                .cornerRadius(12, corners: [.topLeft, .bottomLeft])
                                        )
                                        .onTapGesture {
                                            self.navigationStack.push(ProfileShowActivity(userId: self.viewController.recipe!.owner.documentId))
                                        }
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 20) {
                                        Text("Beschreibung")
                                                .modifier(CommunityCookingTheme.typography.h3)
                                            
                                        Text(self.viewController.recipe!.description)
                                            .modifier(CommunityCookingTheme.typography.body1)
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                        
                                        Text(TranslationService.translate(translatable: self.viewController.recipe!.type.rawValue).uppercased())
                                            .font(Font.system(size: 8))
                                            .padding(.horizontal, 24)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(CommunityCookingTheme.colors.PRIMARY_VARIANT)
                                                    .frame(height: 16, alignment: .center)
                                            )
                                        
                                        HStack(alignment: .center, spacing: 8) {
                                            Text("Zutaten")
                                                .modifier(CommunityCookingTheme.typography.h3)
                                            
                                            Spacer()

                                            Text("Portion")
                                                .font(Font.system(size: 12))
                                            
                                            Text(String(self.viewController.recipe!.portionSize))
                                                .padding(.all, 4)
                                                .background(CommunityCookingTheme.colors.SECONDARY)
                                                .foregroundColor(Color.white)
                                            
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 0) {
                                            ForEach(0..<self.viewController.recipe!.ingredients.count, id: \.self) { index in
                                                HStack {
                                                    Text("\(self.formatNumber(number: self.viewController.recipe!.ingredients[index].amount)) \(TranslationService.ingredientType(ingredientName: self.viewController.recipe!.ingredients[index].unit.rawValue))")
                                                        .font(Font.system(size: 12))
                                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                                    
                                                    Text(self.viewController.recipe!.ingredients[index].name)
                                                        .font(Font.system(size: 12))
                                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                                }
                                                .padding(.all, 4)
                                                .padding(.horizontal, 24)
                                                .background(index % 2 == 1 ? Color.white : CommunityCookingTheme.colors.PRIMARY_VARIANT)
                                            }
                                        }
                                        .padding(.bottom, 8)
                                        
                                        Text("Anleitung")
                                                .modifier(CommunityCookingTheme.typography.h3)
                                        
                                        ForEach(0..<self.viewController.recipe!.steps.count, id: \.self) { index in
                                            HStack(alignment: .top) {
                                                Text("Schritt \(index + 1)")
                                                    .font(Font.system(size: 10))
                                                    .frame(width: 64, height: 16, alignment: .center)
                                                    .background(
                                                        Rectangle()
                                                            .fill(CommunityCookingTheme.colors.PRIMARY_VARIANT)
                                                    )
                                                Text(self.viewController.recipe!.steps[index])
                                                    .font(Font.system(size: 12))
                                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                            }
                                            .padding(.all, 4)
                                        }
                                        
                                    }
                                    .padding(.horizontal, 24)
                                                                    
                                    Spacer().frame(height: 16)
                                    
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
                
                if self.viewController.userId == self.viewController.recipe!.owner.documentId {
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
            self.viewController.downloadData(recipeId: self.recipeId)
        }
    }
    
    private func format(timestamp input: Double) -> String {
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "dd. MMMM yyyy"
        dateTimeFormatter.locale = Locale(identifier: "de_DE")
        return dateTimeFormatter.string(from: Date(timeIntervalSince1970: input))
    }
    
    private func formatNumber(number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        return formatter.string(for: number)!
    }
    
    func onEditClicked() {
        self.navigationStack.push(RecipeEditActivity(recipeId: self.recipeId))
    }
}
