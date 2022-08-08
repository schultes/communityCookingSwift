//
//  ProfileEditActivity.swift
//  communitycooking
//
//  Created by FMA2 on 27.11.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI

struct ProfileEditActivity: View {
    
    @EnvironmentObject private var navigationStack: NavigationStack
    
    @ObservedObject private var viewController = ProfileEditViewController()
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
                                Image("defaultUser")
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
                                AsyncStorageImage(reference: self.viewController.imageId, placeholderImage: PlaceholderImage.USER)
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
                                        
                                    SectionHeader(header: "Wer bist Du?")
                                    
                                    TextFieldNotEmptyValidation(text: self.$viewController.forename, label: "Vorname", error: "Kein Vorname eingegeben!")
                                    TextFieldNotEmptyValidation(text: self.$viewController.lastname , label: "Nachname", error: "Kein Nachname eingegeben!")
                                    EditorFieldNotEmptyValidation(text: self.$viewController.description, label: "Beschreibung", error: "Keine Beschreibung eingegeben!")
                                
                                }
                                
                                Group {
                                    
                                    Spacer().frame(height: 16)
                                    
                                    SectionHeader(header: "Woran bist Du interessiert?")
                                    
                                    VStack(alignment: .leading, spacing: 20) {
                                        
                                        Group {
                                            HStack {
                                                Text("Radius für Eventvorschläge: ")
                                                    .modifier(CommunityCookingTheme.typography.h3)
                                                Text("\(viewController.radiusInKilometer.description.components(separatedBy: ".")[0]) km")
                                                    .foregroundColor(CommunityCookingTheme.colors.PRIMARY)
                                                    .font(Font.system(size: 12).weight(.bold))
                                            }
                                            
                                            HStack(alignment: .center) {
                                                Text("5")
                                                    .modifier(CommunityCookingTheme.typography.body2)
                                                Slider(value: $viewController.radiusInKilometer, in: 5...50, step: 1)
                                                    .accentColor(CommunityCookingTheme.colors.PRIMARY)
                                                Text("50")
                                                    .modifier(CommunityCookingTheme.typography.body2)
                                            }
                                        }
                                        
                                        Group {
                                            Text("Rezeptpräferenz")
                                                .modifier(CommunityCookingTheme.typography.h3)
                                            Picker("Strength", selection: $viewController.recipePreference) {
                                                ForEach(preferences, id: \.self) {
                                                    Text($0)
                                                }
                                            }.pickerStyle(SegmentedPickerStyle())
                                        }
                                    }
                                }
                                
                                Group {
                                    
                                    Spacer().frame(height: 16)
                                        
                                    SectionHeader(header: "Dein Account")
                                    
                                    ZStack(alignment: .topLeading) {
                                        Text(self.viewController.username)
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                            .modifier(CommunityCookingTheme.typography.body1)
                                            .padding(.all, 16)
                                            .padding(.top, 2)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 4)
                                                    .stroke(CommunityCookingTheme.colors.SECONDARY, lineWidth: 1)
                                            )
                                        
                                        Group {
                                            Text("Benutzername")
                                                .font(Font.system(size: 10))
                                                .foregroundColor(CommunityCookingTheme.colors.SECONDARY)
                                                .padding(.horizontal, 4)
                                        }
                                        .background(Color.white)
                                        .padding(.leading, 12)
                                        .offset(y: -6)
                                    }
                                    .padding(.top, 4)
                                    
                                    ZStack(alignment: .topLeading) {
                                        Text(self.viewController.email)
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                            .modifier(CommunityCookingTheme.typography.body1)
                                            .padding(.all, 16)
                                            .padding(.top, 2)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 4)
                                                    .stroke(CommunityCookingTheme.colors.SECONDARY, lineWidth: 1)
                                                    .frame(minWidth: 0, maxWidth: .infinity)
                                            )
                                        
                                        Group {
                                            Text("Emailadresse")
                                                .font(Font.system(size: 10))
                                                .foregroundColor(CommunityCookingTheme.colors.SECONDARY)
                                                .padding(.horizontal, 4)
                                        }
                                        .background(Color.white)
                                        .padding(.leading, 12)
                                        .offset(y: -6)
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .padding(.top, 4)
                                }
                                
                                Button(action: onPasswordChange) {
                                    Text("Passwort ändern!".uppercased())
                                        .font(Font.system(size: 14))
                                        .foregroundColor(Color.white)
                                }
                                .frame(height: 40)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .background(
                                    Rectangle()
                                        .fill(CommunityCookingTheme.colors.SECONDARY)
                                        .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 2)
                                )
                                
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
        .alert(isPresented: self.$viewController.resetShowing) {
            Alert(
                title: Text("Passwort ändern"),
                message: Text("Es wurde eine Email an \"\(TPFirebaseAuthentication.getUser()!.email)\" gesendet, über die Sie Ihr Passwort ändern können. Sie werden nun aus der App abgemeldet und zm Login weitergeleitet!"),
                dismissButton: .default(Text("OK"), action: {
                    AuthenticationService.signOut()
                    NavigationStack.current?.pop(to: .root)
                })
            )
        }
        .sheet(isPresented: self.$viewController.isImageSelectionShowing) {
            ImagePicker(image: self.$viewController.imageSelected)
        }
        .KeyboardAwarePadding(offsetY: -36)
    }
    
    func onSaveClicked() {
        viewController.onSaveClicked()
    }
    
    func onPasswordChange() {
        viewController.onPasswordChange()
    }
}
