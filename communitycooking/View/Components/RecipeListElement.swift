//
//  RecipeListElement.swift
//  communitycooking
//
//  Created by FMA2 on 01.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI

struct RecipeListElement: View {
    
    @EnvironmentObject private var navigationStack: NavigationStack
    
    var recipe: Recipe
    var resultViewController: EventEditViewController? = nil
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(alignment: .top, spacing: 16) {
                
                AsyncStorageImage(reference: self.recipe.image, placeholderImage: PlaceholderImage.RECIPE)
                    .frame(width: 96, height: 96)
                
                VStack(alignment: .leading) {
                    Text(self.recipe.title)
                        .foregroundColor(CommunityCookingTheme.colors.SECONDARY)
                        .font(Font.system(size: 18).weight(.bold))
                        .lineLimit(1)
                    Text(self.recipe.owner.fullname)
                        .foregroundColor(CommunityCookingTheme.colors.PRIMARY)
                        .font(Font.system(size: 12).weight(.bold))
                    Spacer().frame(height: 4)
                    Text("Zubereitungszeit:\t\(self.recipe.duration) Min\nPortionsgröße:\t\t\(self.recipe.portionSize) Personen")
                        .foregroundColor(CommunityCookingTheme.colors.TEXT_PRIMARY)
                        .font(Font.system(size: 10))
                    Spacer()
                    Text(TranslationService.translate(translatable: self.recipe.type.rawValue).uppercased())
                        .font(Font.system(size: 8))
                        .padding(.horizontal, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(CommunityCookingTheme.colors.PRIMARY_VARIANT)
                                .frame(height: 16, alignment: .center)
                        )
                    
                    Spacer().frame(height: 3)
                }
                
                Spacer()
            }
            .padding(.all, 8)
            
            if self.isNew(timestamp: self.recipe.timestamp) {
                Text("NEU")
                    .frame(width: 64, height: 32, alignment: .center)
                    .font(Font.system(size: 12).weight(.bold))
                    .foregroundColor(Color.white)
                    .background(CommunityCookingTheme.colors.WARNING)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .background(
            Rectangle()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 1, x: 2, y: 2)
        )
        .onTapGesture {
            if self.resultViewController == nil {
                self.navigationStack.push(RecipeShowActivity(recipeId: self.recipe.documentId!))
            } else {
                self.resultViewController?.setRecipe(recipe: self.recipe)
                self.navigationStack.pop()
            }
        }
    }
    
    private func isNew(timestamp input: Double) -> Bool {
        return !(Date(timeIntervalSince1970: input) < Calendar.current.date(byAdding: DateComponents(day: -7), to: Date.now)!)
    }
}
