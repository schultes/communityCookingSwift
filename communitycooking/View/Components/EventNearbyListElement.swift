//
//  EventNearbyListElement.swift
//  communitycooking
//
//  Created by FMA2 on 03.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI

struct EventNearbyListElement: View {
    
    @State private var isAlertShowing = false
    
    let viewController: MainViewController
    let event: Event
    
    var body: some View {
        ZStack(alignment: .top) {
            
            AsyncStorageImage(reference: self.event.recipe.image, placeholderImage: PlaceholderImage.RECIPE)
                .frame(width: 96, height: 96, alignment: .center)
                .border(Color.white, width: 4)
                .background(
                    Rectangle()
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 2)
                )
                .onTapGesture {
                    NavigationStack.current?.push(RecipeShowActivity(recipeId: self.event.recipe.documentId!))
                }
                .zIndex(2)
            
            VStack {
                Spacer().frame(height: 40)
                
                VStack(alignment: .center, spacing: 4) {
                    
                    Spacer().frame(height: 48)
                    
                    Text(event.title)
                        .font(Font.system(size: 24).weight(.regular))
                        .foregroundColor(CommunityCookingTheme.colors.SECONDARY)
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height: 4)
                    
                    Text("Das Event ist nur \(String(format: "%.1f", LocationService.calculateDistance(userLocation: self.viewController.userLocation!, eventLocation: event.location)))km von Dir entfernt!")
                        .font(Font.system(size: 10).weight(.bold))
                    
                    Text(format(timestamp: event.timestamp))
                        .foregroundColor(CommunityCookingTheme.colors.PRIMARY)
                        .font(Font.system(size: 10).weight(.bold))
                    
                    Spacer().frame(height: 8)
                    
                    Text(event.description)
                        .modifier(CommunityCookingTheme.typography.body1)
                        .lineLimit(6)
                    
                    Spacer()
                    
                    Text("Anfrage senden")
                        .font(Font.system(size: 10).weight(.bold))
                        .foregroundColor(CommunityCookingTheme.colors.SECONDARY)
                        .padding(.horizontal, 36)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(CommunityCookingTheme.colors.PRIMARY_VARIANT)
                                .frame(height: 24, alignment: .center)
                                .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 2)
                        )
                        .onTapGesture {
                            self.isAlertShowing.toggle()
                        }
                }
                .frame(width: 240, height: 292)
                .padding(.all, 20)
                .background(
                    Rectangle()
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 1, y: 1)
                )
            }
        }
        .actionSheet(isPresented: $isAlertShowing) {
            ActionSheet(
                title: Text("Sicher?"),
                message: Text("Möchtest Du wirklich eine Anfrage für das Event \"\(event.title)\" senden?"),
                buttons: [
                    .default(Text("Senden")) { self.viewController.setRequestForEvent(event: self.event) },
                    .cancel(Text("Abbrechen"))
                ]
            )
        }
    }
    
    private func format(timestamp input: Double) -> String {
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "dd. MMMM yyyy HH:mm"
        dateTimeFormatter.locale = Locale(identifier: "de_DE")
        return dateTimeFormatter.string(from: Date(timeIntervalSince1970: input))
    }
}
