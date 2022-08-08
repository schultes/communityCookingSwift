//
//  CustomPasswordField.swift
//  communitycooking
//
//  Created by FMA2 on 28.11.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI

struct CustomPasswordField: View {
    @Binding var text: String
    var label: String
    var error: String?
    
    @State private var onKeyIn = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 8) {
                SecureField(label, text: $text)
                    .modifier(CommunityCookingTheme.typography.body1)
                    .padding(.all, 16)
                    .padding(.top, 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(error == nil ? CommunityCookingTheme.colors.SECONDARY : CommunityCookingTheme.colors.ERROR, lineWidth: 1)
                    )
                
                if let message = error {
                    Text(message)
                        .font(Font.system(size: 8).weight(.bold))
                        .foregroundColor(CommunityCookingTheme.colors.ERROR)
                        .padding(.leading, 16)
                }
            }
            
            Group {
                Text(label)
                    .font(Font.system(size: 10))
                    .foregroundColor(error == nil ? CommunityCookingTheme.colors.SECONDARY : CommunityCookingTheme.colors.ERROR)
                    .padding(.horizontal, 4)
            }
            .background(Color.white)
            .padding(.leading, 12)
            .offset(y: -6)
        }
        .padding(.top, 4)
    }
}
