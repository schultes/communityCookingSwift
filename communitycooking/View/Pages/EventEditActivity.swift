//
//  EventEditActivity.swift
//  communitycooking
//
//  Created by FMA2 on 27.11.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI

struct EventEditActivity: View {
    
    @EnvironmentObject private var navigationStack: NavigationStack
    
    @ObservedObject private var viewController = EventEditViewController()
        
    var eventId: String?

    init(eventId: String? = nil) {
        self.eventId = eventId
        self.viewController.downloadData(eventId: self.eventId)
    }
    
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
                                                                    
                                    Text(self.viewController.user!.username)
                                        .modifier(CommunityCookingTheme.typography.h3)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                        .padding(.top, 4)
                                    
                                    VStack(spacing: 20) {

                                        SectionHeader(header: "Allgemeine Informationen")
                                            
                                        TextFieldNotEmptyValidation(text: self.$viewController.title, label: "Titel", error: "Kein Titel eingegeben!")
                                        EditorFieldNotEmptyValidation(text: self.$viewController.description, label: "Beschreibung", error: "Keine Beschreibung eingegeben!")
                                        
                                        HStack(alignment: .center, spacing: 20) {
                                            Text("Zeitpunkt für das Event")
                                                .modifier(CommunityCookingTheme.typography.h3)
                                                                                        
                                            DatePicker("", selection: self.$viewController.timestamp)
                                                .labelsHidden()
                                                .frame(minWidth: 0, maxWidth: .infinity)
                                        }
                                        
                                        Toggle(isOn: self.$viewController.isPublic, label: {
                                            Text("Event ist öffentlich sichtbar")
                                                .modifier(CommunityCookingTheme.typography.h3)
                                        }).toggleStyle(SwitchToggleStyle(tint: CommunityCookingTheme.colors.PRIMARY))
                                        
                                        HStack(alignment: .center) {
                                            VStack(alignment: .leading) {
                                                Text("Aktuelle Position des Events")
                                                    .modifier(CommunityCookingTheme.typography.h3)
                                                
                                                Spacer()
                                                
                                                if self.viewController.location != nil {
                                                    VStack(alignment: .leading, spacing: 2) {
                                                        Text("Latitude:\t\t\(self.viewController.location!.latitude)")
                                                            .modifier(CommunityCookingTheme.typography.body1)
                                                        
                                                        Text("Longitude:\t\(self.viewController.location!.longitude)")
                                                            .modifier(CommunityCookingTheme.typography.body1)
                                                    }
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            Button(action: onUpdateLocation) {
                                                Text("Aktualisieren".uppercased())
                                                    .font(Font.system(size: 10).weight(.bold))
                                                    .foregroundColor(Color.white)
                                            }
                                            .frame(width: 120, height: 56)
                                            .background(
                                                Rectangle()
                                                    .fill(CommunityCookingTheme.colors.PRIMARY)
                                            )
                                        }
                                        .frame(height: 56)
                                        
                                        Spacer()
                                        
                                        if self.viewController.recipe != nil {
                                            EventEditRecipeComponent(recipe: self.viewController.recipe!)
                                        }
                                                                            
                                        Button(action: onRecipeSelect) {
                                            Text("Rezept ändern!".uppercased())
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

                                    Spacer()
                                    
                                    VStack(alignment: .leading, spacing: 20) {
                                        if self.viewController.requested.count > 0 {
                                            EventEditRequestingUserList(viewController: self.viewController, users: self.viewController.requested)
                                        }
                                        
                                        if self.viewController.participating.count > 0 {
                                            EventEditParticipatingUserList(viewController: self.viewController, users: self.viewController.participating)
                                        }
                                    }
                                    
                                    if self.viewController.documentId != nil {
                                    
                                        Spacer()
                                        
                                        Button(action: onDeleteClicked) {
                                            Text("Event löschen!".uppercased())
                                                .font(Font.system(size: 14))
                                                .foregroundColor(Color.white)
                                        }
                                        .frame(height: 40)
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .background(
                                            Rectangle()
                                                .fill(CommunityCookingTheme.colors.ERROR)
                                                .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 2)
                                        )
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 20) {
                                                                                
                                        Spacer().frame(height: 16)
                                        
                                        Text("© Community Cooking App 2022")
                                            .modifier(CommunityCookingTheme.typography.body2)
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                    }
                                    
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
        .KeyboardAwarePadding(offsetY: -36)
    }
    
    func onSaveClicked() {
        self.viewController.onSaveClicked()
    }
    
    func onUpdateLocation() {
        self.viewController.findCurrentLocation()
    }
    
    func onDeleteClicked() {
        self.viewController.onDeleteClicked()
    }
    
    func onRecipeSelect() {
        self.navigationStack.push(RecipeListActivity(resultViewController: self.viewController))
    }
}

