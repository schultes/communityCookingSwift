//
//  RecipeEditActivity.swift
//  communitycooking
//
//  Created by FMA2 on 27.11.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI

struct RecipeEditActivity: View {
    
    @EnvironmentObject private var navigationStack: NavigationStack
    
    @ObservedObject private var viewController = RecipeEditViewController()
    @State private var isShowingAddIngredient = false
    @State private var addIngredientName = ""
    @State private var addIngredientAmount: Double = 1
    @State private var addIngredientUnit = IngredientUnit.G.rawValue
    
    private let ingredientUnits = [IngredientUnit.EL.rawValue, IngredientUnit.G.rawValue, IngredientUnit.ML.rawValue, IngredientUnit.PINCH.rawValue, IngredientUnit.TL.rawValue, IngredientUnit.X.rawValue]
    
    @State private var isShowingAddStep = false
    @State private var addStepDescription = ""
    
    var recipeId: String? = nil    
    
    private let preferences = [RecipeType.NONE.rawValue, RecipeType.VEGETARIAN.rawValue, RecipeType.VEGAN.rawValue]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
                
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
                        
                        if self.viewController.imageSelected != nil {
                            ZStack(alignment: .bottomTrailing) {
                                Image(uiImage: self.viewController.imageSelected!)
                                    .resizable()
                                    .frame(width: 128, height: 128, alignment: .center)
                                    .border(Color.white, width: 4)
                                    .background(
                                        Rectangle()
                                            .fill(Color.white)
                                            .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 4)
                                    )
                                    
                                Image("baseline_edit_black_24pt")
                                    .resizable()
                                    .frame(width: 24, height: 24, alignment: .trailing)
                                    .foregroundColor(Color.white)
                                    .padding(8)
                            }
                            .onTapGesture {
                                self.viewController.isImageSelectionShowing.toggle()
                            }
                            .zIndex(2)
                        } else if self.viewController.imageId.isEmpty {
                            ZStack(alignment: .bottomTrailing) {
                                Image("defaultRecipe")
                                    .resizable()
                                    .frame(width: 128, height: 128, alignment: .center)
                                    .border(Color.white, width: 4)
                                    .background(
                                        Rectangle()
                                            .fill(Color.white)
                                            .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 4)
                                    )
                                
                                Image("baseline_edit_black_24pt")
                                    .resizable()
                                    .frame(width: 24, height: 24, alignment: .trailing)
                                    .foregroundColor(Color.white)
                                    .padding(8)
                            }
                            .onTapGesture {
                                self.viewController.isImageSelectionShowing.toggle()
                            }
                            .zIndex(2)
                        } else {
                            ZStack(alignment: .bottomTrailing) {
                                AsyncStorageImage(reference: self.viewController.imageId, placeholderImage: PlaceholderImage.RECIPE)
                                    .frame(width: 128, height: 128, alignment: .center)
                                    .border(Color.white, width: 4)
                                    .background(
                                        Rectangle()
                                            .fill(Color.white)
                                            .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 4)
                                    )
                                
                                Image("baseline_edit_black_24pt")
                                    .resizable()
                                    .frame(width: 24, height: 24, alignment: .trailing)
                                    .foregroundColor(Color.white)
                                    .padding(8)
                            }
                            .onTapGesture {
                                self.viewController.isImageSelectionShowing.toggle()
                            }
                            .zIndex(2)
                        }
                        
                        VStack {
                            
                            Spacer().frame(height: 72)
                            
                            VStack(alignment: .leading, spacing: 20) {
                                
                                Group {
                                                               
                                    Spacer().frame(height: 48)
                                       
                                    SectionHeader(header: "Allgemeine Informationen")
                                    
                                    TextFieldNotEmptyValidation(text: self.$viewController.title, label: "Titel", error: "Kein Titel eingegeben!")
                                    EditorFieldNotEmptyValidation(text: self.$viewController.description, label: "Beschreibung", error: "Keine Beschreibung eingegeben!")

                                    Group {
                                        Text("Rezeptpräferenz")
                                            .modifier(CommunityCookingTheme.typography.h3)
                                        Picker("Strength", selection: self.$viewController.recipePreference) {
                                            ForEach(preferences, id: \.self) {
                                                Text($0)
                                            }
                                        }.pickerStyle(SegmentedPickerStyle())
                                    }
                                }

                                Group {
                                                                   
                                    Spacer().frame(height: 16)
                                       
                                    SectionHeader(header: "Details zum Rezept")
                                   
                                    TextFieldNumberGreaterThanZeroIntValidation(number: self.$viewController.portionSize, label: "Portionsgröße", error: "Die Portionsgröße muss mindestens 1 sein!")
                                    TextFieldNumberGreaterThanZeroIntValidation(number: self.$viewController.durationInMinutes, label: "Dauer in Minuten", error: "Die Dauer in Minuten muss mindestens 1 sein!")

                                }
                                
                                VStack(spacing: 16) {
                                    HStack(alignment: .center) {
                                                                            
                                        Text("Zutaten")
                                            .modifier(CommunityCookingTheme.typography.h3)
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                                                            
                                        Image("baseline_add_black_24pt")
                                            .resizable()
                                            .foregroundColor(Color.white)
                                            .background(RoundedRectangle(cornerRadius: 4).fill(CommunityCookingTheme.colors.PRIMARY).frame(width: 24, height: 24, alignment: .center))
                                            .frame(width: 16, height: 16, alignment: .trailing)
                                            .onTapGesture {
                                                self.isShowingAddIngredient.toggle()
                                            }
                                        
                                    }
                                    .sheet(isPresented: self.$isShowingAddIngredient) {
                                        VStack(spacing: 20) {
                                            
                                            Text("Füge eine neue Zutat hinzu!")
                                                .modifier(CommunityCookingTheme.typography.h2)
                                            
                                            TextFieldNotEmptyValidation(text: self.$addIngredientName, label: "Name", error: "Kein Name eingegeben!")
                                            TextFieldNumberGreaterThanZeroDoubleValidation(number: self.$addIngredientAmount, label: "Menge", error: "Die Menge muss größer als 0 sein!")
                                            
                                            Picker("Ingredient", selection: self.$addIngredientUnit) {
                                                ForEach(self.ingredientUnits, id: \.self) {
                                                    Text($0)
                                                }
                                            }.pickerStyle(SegmentedPickerStyle())
                                            
                                            Spacer()
                                            
                                            Button(action: self.onAddIngredientClicked) {
                                                Text("Hinzufügen".uppercased())
                                                    .font(Font.system(size: 14))
                                                    .foregroundColor(Color.white)
                                            }
                                            .frame(height: 40)
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                            .background(
                                                Rectangle()
                                                    .fill(CommunityCookingTheme.colors.PRIMARY)
                                                    .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 2)
                                            )
                                            
                                        }
                                        .padding(.all, 24)
                                    }
                                    
                                    ForEach(Array(zip(self.viewController.ingredients.indices, self.viewController.ingredients)) , id: \.1) { index, element in
                                        RecipeEditIngredientElement(viewController: self.viewController, index: index)
                                    }
                                }
                                .padding(.top, 16)
                                
                                VStack(spacing: 16) {
                                    HStack(alignment: .center) {
                                                                            
                                        Text("Bearbeitungsschritte")
                                            .modifier(CommunityCookingTheme.typography.h3)
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                                                            
                                        Image("baseline_add_black_24pt")
                                            .resizable()
                                            .foregroundColor(Color.white)
                                            .background(RoundedRectangle(cornerRadius: 4).fill(CommunityCookingTheme.colors.PRIMARY).frame(width: 24, height: 24, alignment: .center))
                                            .frame(width: 16, height: 16, alignment: .trailing).onTapGesture {
                                                self.isShowingAddStep.toggle()
                                            }
                                        
                                    }
                                    .sheet(isPresented: self.$isShowingAddStep) {
                                        VStack(spacing: 20) {
                                            
                                            Text("Füge einen neuen Schritt hinzu!")
                                                .modifier(CommunityCookingTheme.typography.h2)
                                            
                                            EditorFieldNotEmptyValidation(text: self.$addStepDescription, label: "Beschreibung", error: "Keine Beschreibung eingegeben!")
                                            
                                            Spacer()
                                            
                                            Button(action: self.onAddStepClicked) {
                                                Text("Hinzufügen".uppercased())
                                                    .font(Font.system(size: 14))
                                                    .foregroundColor(Color.white)
                                            }
                                            .frame(height: 40)
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                            .background(
                                                Rectangle()
                                                    .fill(CommunityCookingTheme.colors.PRIMARY)
                                                    .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 2)
                                            )
                                            
                                        }
                                        .padding(.all, 24)
                                    }
                                    
                                    ForEach(Array(zip(self.viewController.steps.indices, self.viewController.steps)) , id: \.1) { index, element in
                                        RecipeEditStepElement(viewController: self.viewController, index: index)
                                    }
                                }
                                .padding(.top, 24)
                                
                                Spacer().frame(height: 16)
                                
                                Text("© Community Cooking App 2022")
                                    .modifier(CommunityCookingTheme.typography.body2)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                
                            }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding(.all, 24)
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
            
            Button(action: onSaveClicked, label: {
                Image("baseline_save_black_24pt")
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
        .sheet(isPresented: self.$viewController.isImageSelectionShowing) {
            ImagePicker(image: self.$viewController.imageSelected)
        }
        .onAppear() {
            self.viewController.downloadData(recipeId: self.recipeId)
        }
        .KeyboardAwarePadding(offsetY: -36)
    }
    
    func onAddIngredientClicked() {
        self.addIngredientName = self.addIngredientName.trimming(spaces: .leadingAndTrailing)
        if !self.addIngredientName.isEmpty && self.addIngredientAmount > 0 {
            self.viewController.ingredients.append(Ingredient(name: self.addIngredientName, amount: self.addIngredientAmount, unit: IngredientUnit(rawValue: self.addIngredientUnit)!))
            self.addIngredientName = ""
            self.addIngredientAmount = 1
            self.addIngredientUnit = IngredientUnit.G.rawValue
            self.isShowingAddIngredient = false
        }
    }
    
    func onAddStepClicked() {
        self.addStepDescription = self.addStepDescription.trimming(spaces: .leadingAndTrailing)
        if !self.addStepDescription.isEmpty {
            self.viewController.steps.append(self.addStepDescription)
            self.addStepDescription = ""
            self.isShowingAddStep = false
        }
    }
    
    func onSaveClicked() {
        self.viewController.onSaveClicked()
    }
}
