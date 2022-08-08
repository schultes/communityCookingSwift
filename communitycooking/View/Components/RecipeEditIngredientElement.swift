//
//  RecipeEditIngredientElement#.swift
//  communitycooking
//
//  Created by FMA2 on 06.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI

struct RecipeEditIngredientElement: View {
    
    @State private var isShowingEditIngredient = false
    
    @State private var ingredientName = ""
    @State private var ingredientAmount: Double = 1
    @State private var ingredientUnit = IngredientUnit.G.rawValue
    
    private let ingredientUnits = [IngredientUnit.EL.rawValue, IngredientUnit.G.rawValue, IngredientUnit.ML.rawValue, IngredientUnit.PINCH.rawValue, IngredientUnit.TL.rawValue, IngredientUnit.X.rawValue]
    
    let viewController: RecipeEditViewController
    let index: Int
    
    var body: some View {
        HStack(alignment: .center) {
                                                
            Text("\(self.formatNumber(number: ingredientAmount))\(TranslationService.ingredientType(ingredientName: ingredientUnit)) \(ingredientName)")
                .modifier(CommunityCookingTheme.typography.body1)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                                
            Image("baseline_edit_black_24pt")
                .resizable()
                .foregroundColor(Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(CommunityCookingTheme.colors.WARNING)
                        .frame(width: 24, height: 24, alignment: .center)
                )
                .frame(width: 16, height: 16, alignment: .trailing)
                .onTapGesture {
                    self.isShowingEditIngredient.toggle()
                }
        }
        .sheet(isPresented: self.$isShowingEditIngredient) {
            VStack(spacing: 20) {
                
                Text("Füge eine neue Zutat hinzu!")
                    .modifier(CommunityCookingTheme.typography.h2)
                
                TextFieldNotEmptyValidation(text: self.$ingredientName, label: "Name", error: "Kein Name eingegeben!")
                TextFieldNumberGreaterThanZeroDoubleValidation(number: self.$ingredientAmount, label: "Menge", error: "Die Menge muss größer als 0 sein!")
                
                Picker("Ingredient", selection: self.$ingredientUnit) {
                    ForEach(self.ingredientUnits, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: self.onDeleteClicked) {
                        Text("Löschen".uppercased())
                            .font(Font.system(size: 14))
                            .foregroundColor(Color.white)
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .frame(height: 40)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(
                        Rectangle()
                            .fill(CommunityCookingTheme.colors.ERROR)
                            .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 2)
                    )
                    
                    Button(action: self.onSaveClicked) {
                        Text("Speichern".uppercased())
                            .font(Font.system(size: 14))
                            .foregroundColor(Color.white)
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .frame(height: 40)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(
                        Rectangle()
                            .fill(CommunityCookingTheme.colors.PRIMARY)
                            .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 2)
                    )
                }
            }
            .padding(.all, 24)
        }
        .onAppear {
            let ingredient = self.viewController.ingredients[self.index]
            
            self.ingredientName = ingredient.name
            self.ingredientAmount = ingredient.amount
            self.ingredientUnit = ingredient.unit.rawValue
        }
    }
    
    private func formatNumber(number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        return formatter.string(for: number)!
    }
    
    func onDeleteClicked(){
        self.viewController.ingredients.remove(at: index)
        self.isShowingEditIngredient = false
    }
    
    func onSaveClicked() {
        self.viewController.ingredients[self.index] = Ingredient(name: self.ingredientName, amount: self.ingredientAmount, unit: IngredientUnit(rawValue: self.ingredientUnit)!)
        self.isShowingEditIngredient = false
    }
}
