//
//  EventChatActivity.swift
//  communitycooking
//
//  Created by FMA2 on 27.11.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI

struct EventChatActivity: View {
    
    @EnvironmentObject private var navigationStack: NavigationStack
    
    @ObservedObject private var viewController = EventChatViewController()
    
    @State private var message: String = ""
    
    var context: String
    
    var body: some View {
        VStack(spacing: 0) {
            
            if self.viewController.isLoaded() {
            
                VStack {
                    
                    Spacer().frame(height: 36)
                    
                    HStack(alignment: .center, spacing: 12) {
                        Group {
                            Image("baseline_arrow_back_black_24pt")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .foregroundColor(Color.white)
                        }
                        .frame(width: 60, height: 60, alignment: .center)
                        .onTapGesture {
                            self.navigationStack.pop()
                        }
                        
                        AsyncStorageImage(reference: self.viewController.event!.recipe.image, placeholderImage: PlaceholderImage.RECIPE)
                            .frame(width: 36, height: 36, alignment: .center)
                            .border(Color.white, width: 2)
                            
                        Text(self.viewController.event!.title)
                            .font(Font.system(size: 18).weight(.bold))
                            .foregroundColor(Color.white)
                            .padding(.leading, 12)
                    }
                    .frame(height: 96)
                }
                .frame(height: 96)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .background(CommunityCookingTheme.colors.SECONDARY)
                
                Spacer().frame(height: 1).frame(minWidth: 0, maxWidth: .infinity).background(Color.white)
                
                ScrollView {
                    
                    VStack(spacing: 8) {
                        ForEach(self.viewController.messages, id: \.self) { message in
                            ChatElement(message: message)
                                .frame(minWidth: 0, maxWidth: .infinity)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.all, 8)
                
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .background(CommunityCookingTheme.colors.SECONDARY)
                .flippedUpsideDown()
                
                VStack {
                    HStack(alignment: .center, spacing: 0) {
                        
                        Group {
                            TextField("Tippe einfach drauf los ...", text: $message)
                                .font(Font.system(size: 12))
                                .padding(.all, 8)
                        }
                        .frame(height: 48)
                        .background(Color.white)
                        
                        Group {
                            Image("baseline_send_black_24pt")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(CommunityCookingTheme.colors.SECONDARY)
                        }
                        .frame(width: 48, height: 48, alignment: .center)
                        .onTapGesture {
                            self.message = self.message.trimming(spaces: .leadingAndTrailing)
                            
                            if !self.message.isEmpty {
                                self.viewController.sendMessage(context: self.context, message: self.message)
                                self.message = ""
                            }
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .KeyboardAwarePadding(offsetY: -36)
                
                Spacer().frame(height: 36)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.white)
                
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
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.black)
        .navigationBarTitle("")
        .navigationBarHidden(false)
        .edgesIgnoringSafeArea(.all)
        .onAppear() {
            self.viewController.downloadData(context: self.context)
        }
    }
}
