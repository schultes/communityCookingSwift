//
//  EventEditRecipeComponent.swift
//  communitycooking
//
//  Created by FMA2 on 01.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI

struct EventEditRecipeComponent: View {
    
    @EnvironmentObject private var navigationStack: NavigationStack
    
    var recipe: Recipe
    
    var body: some View {
        ZStack(alignment: .top) {
            
            AsyncStorageImage(reference: self.recipe.image, placeholderImage: PlaceholderImage.RECIPE)
                .frame(width: 96, height: 96, alignment: .center)
                .border(Color.white, width: 4)
                .background(
                    Rectangle()
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 4)
                )
                .onTapGesture {
                    self.navigationStack.push(RecipeShowActivity(recipeId: self.recipe.documentId!))
                }
                .zIndex(2)
            
            VStack {
                Spacer().frame(height: 40)
                
                VStack(alignment: .center, spacing: 8) {
                    HStack {
                        VStack(alignment: .center) {
                            Image("baseline_person_black_24pt")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(CommunityCookingTheme.colors.SECONDARY)
                            Text(self.recipe.owner.fullname)
                                .font(Font.system(size: 12).weight(.bold))
                                .foregroundColor(CommunityCookingTheme.colors.SECONDARY)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 64)
                        
                        Spacer().frame(minWidth: 0, maxWidth: .infinity)
                        
                        VStack(alignment: .center) {
                            Image("baseline_access_time_filled_black_24pt")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(CommunityCookingTheme.colors.SECONDARY)
                            Text("\(self.recipe.duration) Min")
                                .font(Font.system(size: 12).weight(.bold))
                                .foregroundColor(CommunityCookingTheme.colors.SECONDARY)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 64)
                    }
                    
                    Text(self.recipe.title)
                        .modifier(CommunityCookingTheme.typography.h2)
                    
                    Text(self.recipe.description)
                        .modifier(CommunityCookingTheme.typography.body1)
                    
                    Spacer()
                    
                    Text(TranslationService.translate(translatable: self.recipe.type.rawValue).uppercased())
                        .font(Font.system(size: 10))
                        .padding(.horizontal, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(CommunityCookingTheme.colors.PRIMARY_VARIANT)
                                .frame(height: 24, alignment: .center)
                        )
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.all, 20)
                .background(
                    Rectangle()
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 1, y: 1)
                )
            }
            .onTapGesture {
                self.navigationStack.push(RecipeShowActivity(recipeId: self.recipe.documentId!))
            }
        }
    }
}
