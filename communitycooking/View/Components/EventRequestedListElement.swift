//
//  EventReqiestedListElement.swift
//  communitycooking
//
//  Created by FMA2 on 02.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI

struct EventRequestedListElement: View {
    
    @State private var isAlertShowing = false
    
    let viewController: MainViewController
    let event: Event
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            AsyncStorageImage(reference: self.event.recipe.image, placeholderImage: PlaceholderImage.RECIPE)
                .frame(width: 72, height: 72)
                .border(Color.white, width: 4)
                .background(
                    Rectangle()
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 2)
                )
                .onTapGesture {
                    NavigationStack.current?.push(RecipeShowActivity(recipeId: self.event.recipe.documentId!))
                }
            
            VStack(alignment: .leading) {
                Text(event.title)
                    .foregroundColor(CommunityCookingTheme.colors.SECONDARY)
                    .font(Font.system(size: 16).weight(.bold))
                    .lineLimit(1)
                Text(event.owner.fullname)
                    .foregroundColor(CommunityCookingTheme.colors.PRIMARY)
                    .font(Font.system(size: 12).weight(.bold))
                    .lineLimit(1)
                Spacer().frame(height: 12)
                HStack {
                    Spacer()
                    Text("Anfrage zurückziehen")
                        .font(Font.system(size: 10).weight(.bold))
                        .foregroundColor(CommunityCookingTheme.colors.SECONDARY)
                    Spacer()
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(CommunityCookingTheme.colors.PRIMARY_VARIANT)
                        .frame(height: 24, alignment: .center)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 2)
                )
                .frame(height: 24, alignment: .center)
                .frame(minWidth: 0, maxWidth: .infinity)
                .onTapGesture {
                    self.isAlertShowing.toggle()
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
        }
        .padding(.all, 8)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .background(
            Rectangle()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 1, x: 2, y: 2)
        )
        .actionSheet(isPresented: $isAlertShowing) {
            ActionSheet(
                title: Text("Sicher?"),
                message: Text("Möchtest Du Deine Anfrage zum Event \"\(event.title)\" wirklich zurückziehen?"),
                buttons: [
                    .default(Text("Zurückziehen")) { self.viewController.removeRequestForEvent(event: self.event) },
                    .cancel(Text("Abbrechen"))
                ]
            )
        }
    }
}
