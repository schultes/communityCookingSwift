//
//  EventShowActivity.swift
//  communitycooking
//
//  Created by FMA2 on 27.11.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI

struct EventShowActivity: View {
    
    @EnvironmentObject private var navigationStack: NavigationStack
    
    @ObservedObject private var viewController = EventShowViewController()
    
    let eventId: String
    
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
                            
                            AsyncStorageImage(reference: self.viewController.event!.recipe.image, placeholderImage: PlaceholderImage.RECIPE)
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
                                        Text("Willkommen bei\n\(self.viewController.event!.title)!")
                                            .modifier(CommunityCookingTheme.typography.h1)
                                            .multilineTextAlignment(.center)
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                            .multilineTextAlignment(.center)
                                        
                                        Text(self.format(timestamp: self.viewController.event!.timestamp))
                                            .modifier(CommunityCookingTheme.typography.h3)
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                    }
                                    
                                    HStack(alignment: .center) {
                                        Spacer()
                                        
                                        HStack(alignment: .center, spacing: 8) {
                                            Image("baseline_person_black_24pt")
                                                .resizable()
                                                .frame(width: 14, height: 14, alignment: .center)
                                                .foregroundColor(Color.white)
                                            
                                            Text(self.viewController.event!.owner.fullname)
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
                                            self.navigationStack.push(ProfileShowActivity(userId: self.viewController.event!.owner.documentId))
                                        }
                                    }
                                    
                                    Group {
                                        Text("Über das Event")
                                            .modifier(CommunityCookingTheme.typography.h3)
                                        
                                        Text(self.viewController.event!.description)
                                            .modifier(CommunityCookingTheme.typography.body1)
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    
                                        EventEditRecipeComponent(recipe: self.viewController.event!.recipe)
                                            .padding(.bottom, 16)
                                        
                                        HStack(alignment: .center, spacing: 8) {
                                            Text("Zutaten")
                                                .modifier(CommunityCookingTheme.typography.h3)
                                            
                                            Spacer()

                                            Text("Portion")
                                                .font(Font.system(size: 12))
                                            
                                            Text(String(self.viewController.event!.participating.count + 1))
                                                .padding(.all, 4)
                                                .background(CommunityCookingTheme.colors.SECONDARY)
                                                .foregroundColor(Color.white)
                                            
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 0) {
                                            ForEach(0..<self.viewController.event!.recipe.ingredients.count, id: \.self) { index in
                                                HStack {
                                                    Text("\(self.adjustIngredientForMemeberSize(index: index, event: self.viewController.event!)) \(TranslationService.ingredientType(ingredientName: self.viewController.event!.recipe.ingredients[index].unit.rawValue))")
                                                        .font(Font.system(size: 12))
                                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                                    Text(self.viewController.event!.recipe.ingredients[index].name)
                                                        .font(Font.system(size: 12))
                                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                                }
                                                .padding(.all, 4)
                                                .padding(.horizontal, 24)
                                                .background(index % 2 == 1 ? Color.white : CommunityCookingTheme.colors.PRIMARY_VARIANT)
                                            }
                                        }
                                        .padding(.bottom, 8)
                                    }
                                    .padding(.horizontal, 24)
                                    
                                    VStack(spacing: 16) {
                                                               
                                        HStack(alignment: .center) {
                                            Text("Teilnehmer")
                                                .modifier(CommunityCookingTheme.typography.h3)
                                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                                .padding(.leading, 24)
                                            
                                            Spacer()
                                            
                                            HStack(alignment: .center, spacing: 24) {
                                                Image("baseline_chat_black_24pt")
                                                    .resizable()
                                                    .frame(width: 18, height: 18, alignment: .center)
                                                    .foregroundColor(Color.white)
                                                
                                                Text("Chat")
                                                    .font(Font.system(size: 16).weight(.bold))
                                                    .foregroundColor(Color.white)
                                            }
                                            .padding(.all, 8)
                                            .padding(.horizontal, 8)
                                            .background(
                                                CommunityCookingTheme.colors.PRIMARY
                                                    .frame(height: 36)
                                                    .cornerRadius(18, corners: [.topLeft, .bottomLeft])
                                            )
                                            .onTapGesture {
                                                self.navigationStack.push(EventChatActivity(context: self.viewController.event!.documentId!))
                                            }
                                        }
                                        
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 8) {
                                                ForEach(0..<self.viewController.event!.participating.count, id: \.self) { index in
                                                    
                                                    VStack(alignment: .center, spacing: 4) {
                                                    
                                                        AsyncStorageImage(reference: self.viewController.event!.participating[index].image, placeholderImage: PlaceholderImage.USER)
                                                            .frame(width: 128, height: 128, alignment: .center)
                                                        
                                                        Text(self.viewController.event!.participating[index].username)
                                                            .foregroundColor(CommunityCookingTheme.colors.SECONDARY)
                                                            .font(Font.system(size: 10).weight(.bold))
                                                            .padding(.bottom, 4)
                                                            .padding(.vertical, 8)
                                                        
                                                    }
                                                    .border(Color.white, width: 4)
                                                    .background(
                                                        Rectangle()
                                                            .fill(Color.white)
                                                            .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 2)
                                                    )
                                                    .onTapGesture {
                                                        self.navigationStack.push(ProfileShowActivity(userId: self.viewController.event!.participating[index].documentId))
                                                    }
                                                }
                                            }
                                            .padding(.horizontal, 24)
                                            .padding(.vertical, 4)
                                        }
                                        
                                        Spacer().frame(height: 16)
                                             
                                        if TPFirebaseAuthentication.getUser()?.uid != self.viewController.event!.owner.documentId {
                                            Group {
                                                Button(action: onLeaveEventClicked) {
                                                    Text("Event verlassen!".uppercased())
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
                                                .onTapGesture {
                                                    self.viewController.leaveEvent()
                                                }
                                            }
                                            .padding(.horizontal, 24)
                                        }
                                    }
                                    
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
            
                if self.viewController.userId == self.viewController.event!.owner.documentId {
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
            self.viewController.downloadData(eventId: self.eventId)
        }
    }
    
    func adjustIngredientForMemeberSize(index: Int, event: Event) -> String {
        let initialNumber = event.recipe.ingredients[index].amount
        let memberSize = event.participating.count + 1
        let portionSize = event.recipe.portionSize
        
        let finalNumber = (Double(initialNumber) / Double(portionSize)) * Double(memberSize)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        
        return formatter.string(for: finalNumber)!
    }
    
    private func format(timestamp input: Double) -> String {
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "dd. MMMM yyyy HH:mm"
        dateTimeFormatter.locale = Locale(identifier: "de_DE")
        return dateTimeFormatter.string(from: Date(timeIntervalSince1970: input))
    }
        
    func onEditClicked() {
        self.navigationStack.push(EventEditActivity(eventId: self.eventId))
    }
    
    func onLeaveEventClicked() {
        self.viewController.leaveEvent()
    }
}
