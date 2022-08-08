//
//  EventParticipatingListElement.swift
//  communitycooking
//
//  Created by FMA2 on 02.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI

struct EventParticipatingListElement: View {
    
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
                Spacer()
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text("Termin")
                            .foregroundColor(CommunityCookingTheme.colors.TEXT_PRIMARY)
                            .font(Font.system(size: 10))
                            .frame(width: 64, alignment: .leading)
                        
                        Text(String(format(timestamp: event.timestamp)))
                            .foregroundColor(CommunityCookingTheme.colors.PRIMARY)
                            .font(Font.system(size: 10))
                            .lineLimit(1)
                    }
                    
                    HStack {
                        Text("Rezept")
                            .foregroundColor(CommunityCookingTheme.colors.TEXT_PRIMARY)
                            .font(Font.system(size: 10))
                            .frame(width: 64, alignment: .leading)
                        
                        Text(event.recipe.title)
                            .foregroundColor(CommunityCookingTheme.colors.PRIMARY)
                            .font(Font.system(size: 10))
                            .lineLimit(1)
                    }
                }
            }
            
            Spacer()
            
            Image("baseline_arrow_forward_ios_black_24pt")
                .resizable()
                .frame(width: 18, height: 18, alignment: .center)
                .foregroundColor(CommunityCookingTheme.colors.SECONDARY)
        }
        .padding(.all, 8)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .background(
            Rectangle()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 1, x: 2, y: 2)
        )
        .onTapGesture {
            NavigationStack.current?.push(EventShowActivity(eventId: self.event.documentId!))
        }
    }
    
    private func format(timestamp input: Double) -> String {
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "dd. MMMM yyyy HH:mm"
        dateTimeFormatter.locale = Locale(identifier: "de_DE")
        return dateTimeFormatter.string(from: Date(timeIntervalSince1970: input))
    }
}
