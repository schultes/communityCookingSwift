//
//  MainActivity.swift
//  communitycooking
//
//  Created by FMA2 on 27.11.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI

struct MainActivity: View {
    
    @EnvironmentObject private var navigationStack: NavigationStack
    
    @ObservedObject private var viewController = MainViewController()
    
    let welcomeTextList = ["Willkommen", "Hallo", "Moin"]
    let motivationalTextList = ["Heute ist ein schöner Tag zum kochen!", "So viele Rezepte! Was kochst Du nach?"]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
        
            ScrollView {
                
                Group {
                    
                    Spacer().frame(height: 80)
                    
                    VStack(spacing: 64) {
                        
                        Group {
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Group {
                                    
                                    HStack(spacing: 16) {
                                        
                                        if self.viewController.user == nil {
                                            Image("defaultUser")
                                                .resizable()
                                                .frame(width: 88, height: 88)
                                                .border(Color.white, width: 4)
                                                .background(
                                                    Rectangle()
                                                        .fill(Color.white)
                                                        .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 2)
                                                )
                                                .offset(y: -16)
                                        } else {
                                            AsyncStorageImage(reference: self.viewController.user!.image, placeholderImage: PlaceholderImage.USER)
                                                .frame(width: 88, height: 88)
                                                .border(Color.white, width: 4)
                                                .background(
                                                    Rectangle()
                                                        .fill(Color.white)
                                                        .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 2)
                                                )
                                                .offset(y: -16)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 2) {

                                            Text("\(welcomeTextList.randomElement()!) \(viewController.user?.forename ?? "Nutzer")!")
                                                .font(Font.system(size: 16).weight(.bold))
                                                .foregroundColor(CommunityCookingTheme.colors.SECONDARY)

                                            Text(motivationalTextList.randomElement()!)
                                                .font(Font.system(size: 10))
                                                .foregroundColor(CommunityCookingTheme.colors.PRIMARY)
                                            
                                        }
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                        
                                        Image("baseline_arrow_forward_ios_black_24pt")
                                            .resizable()
                                            .frame(width: 18, height: 18, alignment: .center)
                                            .foregroundColor(CommunityCookingTheme.colors.SECONDARY)
                                    }
                                    
                                }
                                .padding(.all, 8)
                                .frame(height: 64)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 72, alignment: .leading)
                                .background(Rectangle().fill(Color.white))
                                .onTapGesture {
                                    self.navigationStack.push(ProfileEditActivity())
                                }
                                
                                
                                Group {
                                    
                                    HStack(alignment: .center) {
                                        Text("Durchstöbere alle Rezepte nach neuen Ideen")
                                            .font(Font.system(size: 12).weight(.bold))
                                            .foregroundColor(Color.white)
                                        
                                        Spacer()
                                        
                                        Image("baseline_arrow_forward_ios_black_24pt")
                                            .resizable()
                                            .frame(width: 18, height: 18, alignment: .center)
                                            .foregroundColor(Color.white)
                                    }
                                    
                                }
                                .padding(.all, 8)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                .background(
                                    Rectangle().fill(CommunityCookingTheme.colors.PRIMARY)
                                )
                                .onTapGesture {
                                    self.navigationStack.push(RecipeListActivity())
                                }
                            }
                            .background(Rectangle().shadow(color: Color.black.opacity(0.2), radius: 1, x: 2, y: 2))
                            
                        }
                        .padding(.horizontal, 24)
                        
                        if viewController.nearbyEvents.count > 0 {
                            VStack(spacing: 16){
                                
                                SectionHeader(header: "\(viewController.nearbyEvents.count) Event\(viewController.nearbyEvents.count > 1 ? "s" : "") in Deiner Nähe", tint: Color.white)
                                    .foregroundColor(Color.white)
                                    .padding(.horizontal, 24)
                                        
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(viewController.nearbyEvents.sorted(by: { LocationService.calculateDistance(userLocation: self.viewController.userLocation!, eventLocation: $0.location) < LocationService.calculateDistance(userLocation: self.viewController.userLocation!, eventLocation: $1.location) }), id: \.self) { element in
                                            EventNearbyListElement(viewController: self.viewController, event: element)
                                        }
                                    }
                                    .padding(.horizontal, 24)
                                }
                            }
                        }
                        
                        
                        if viewController.requestedEvents.count > 0 {
                            VStack(spacing: 16){
                                
                                SectionHeader(header: "Ausstehende Eventanfragen", tint: Color.white)
                                    .foregroundColor(Color.white)
                                    
                                VStack(spacing: 16) {
                                    ForEach(viewController.requestedEvents.sorted(by: { $0.timestamp < $1.timestamp }), id: \.self) { element in
                                        EventRequestedListElement(viewController: self.viewController, event: element)
                                    }
                                }
                                
                            }
                            .padding(.horizontal, 24)
                        }
                        
                        
                        if viewController.participatingEvents.count > 0 {
                            VStack(spacing: 16) {
                                
                                SectionHeader(header: "Beigetretene Events", tint: Color.white)
                                    .foregroundColor(Color.white)
                                
                                VStack(spacing: 16) {
                                    ForEach(viewController.participatingEvents.sorted(by: { $0.timestamp < $1.timestamp }), id: \.self) { element in
                                        EventParticipatingListElement(event: element)
                                    }
                                }
                                
                            }
                            .padding(.horizontal, 24)
                        }
                        
                    }
                    
                    Group {
                        Spacer().frame(height: 48)
                        
                        Text("Abmelden")
                            .foregroundColor(Color.white)
                            .font(Font.system(size: 12).weight(.bold))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            .onTapGesture {
                                self.onSignOutClicked()
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
            
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            
            Button(action: self.onAddClicked, label: {
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
        .onAppear() {
            self.viewController.downloadData()
        }
    }
    
    func onAddClicked() {
        self.navigationStack.push(EventEditActivity())
    }
    
    func onSignOutClicked() {
        AuthenticationService.signOut()
        self.navigationStack.pop(to: .root)
    }
}
