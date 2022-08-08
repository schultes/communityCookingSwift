//
//  ChatElement.swift
//  communitycooking
//
//  Created by FMA2 on 06.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI

struct ChatElement: View {
    
    var message: Message
    
    var body: some View {
        Group {
            if TPFirebaseAuthentication.getUser()!.uid == self.message.user.documentId {
                ChatRightElement(message: message)
            } else {
                ChatLeftElement(message: message)
            }
        }
    }
}

struct ChatLeftElement: View {
    
    @EnvironmentObject private var navigationStack: NavigationStack
    
    var message: Message
    
    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: 8) {
                Text(self.message.user.username)
                    .font(Font.system(size: 12).weight(.bold))
                    .foregroundColor(CommunityCookingTheme.colors.PRIMARY)

                Text(self.message.text)
                    .font(Font.system(size: 12))
                    .foregroundColor(CommunityCookingTheme.colors.TEXT_PRIMARY)

                Text(self.format(timestamp: self.message.timestamp))
                    .font(Font.system(size: 10))
                    .foregroundColor(CommunityCookingTheme.colors.TEXT_PRIMARY)
            }
            .padding(.all, 8)
            .background(
                RoundedCorner(radius: 8)
                    .foregroundColor(Color.white)
            )
        }
        .padding(.trailing, 128)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .flippedUpsideDown()
        .onTapGesture {
            self.navigationStack.push(ProfileShowActivity(userId: self.message.user.documentId))
        }
    }
        
    private func format(timestamp input: Double) -> String {
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "dd. MMMM yyyy HH:mm"
        dateTimeFormatter.locale = Locale(identifier: "de_DE")
        return dateTimeFormatter.string(from: Date(timeIntervalSince1970: input))
    }
}

struct ChatRightElement: View {
    
    @EnvironmentObject private var navigationStack: NavigationStack
    
    var message: Message
    
    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: 8) {
                Text(self.message.text)
                    .font(Font.system(size: 12))
                    .foregroundColor(CommunityCookingTheme.colors.TEXT_PRIMARY)

                Text(self.format(timestamp: self.message.timestamp))
                    .font(Font.system(size: 10))
                    .foregroundColor(CommunityCookingTheme.colors.TEXT_PRIMARY)
            }
            .padding(.all, 8)
            .background(
                ZStack {
                    RoundedCorner(radius: 8)
                        .foregroundColor(Color.white)
                    
                    RoundedCorner(radius: 8)
                        .foregroundColor(CommunityCookingTheme.colors.PRIMARY_VARIANT)
                }
            )
        }
        .padding(.leading, 128)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
        .flippedUpsideDown()
        .onTapGesture {
            self.navigationStack.push(ProfileShowActivity(userId: self.message.user.documentId))
        }
    }
        
    private func format(timestamp input: Double) -> String {
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "dd. MMMM yyyy HH:mm"
        dateTimeFormatter.locale = Locale(identifier: "de_DE")
        return dateTimeFormatter.string(from: Date(timeIntervalSince1970: input))
    }
}
