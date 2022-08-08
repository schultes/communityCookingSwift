//
//  RecipeEditStepElement.swift
//  communitycooking
//
//  Created by FMA2 on 06.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI

struct RecipeEditStepElement: View {
    
    @State private var isShowingEditStep = false
    @State private var text = ""
    
    let viewController: RecipeEditViewController
    let index: Int
    
    var body: some View {
        HStack(alignment: .top) {
                                                
            Text(self.viewController.steps[self.index])
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
                    self.isShowingEditStep.toggle()
                }
            
        }
        .sheet(isPresented: $isShowingEditStep) {
            VStack(spacing: 20) {
                
                Text("Bearbeite diesen Schritt!")
                    .modifier(CommunityCookingTheme.typography.h2)
                
                EditorFieldNotEmptyValidation(text: self.$text, label: "Beschreibung", error: "Keine Beschreibung eingegeben!")
                
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
            self.text = self.viewController.steps[self.index]
        }
    }
    
    func onDeleteClicked(){
        self.viewController.steps.remove(at: index)
        self.isShowingEditStep = false
    }
    
    func onSaveClicked() {
        self.viewController.steps[self.index] = self.text
        self.isShowingEditStep = false
    }
}
