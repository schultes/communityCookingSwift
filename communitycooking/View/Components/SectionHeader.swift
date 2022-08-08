//
//  SectionHeader.swift
//  communitycooking
//
//  Created by FMA2 on 28.11.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI

struct SectionHeader: View {
    
    var header: String
    var tint: Color?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(header)
                .bold()
                .foregroundColor(tint ?? CommunityCookingTheme.colors.SECONDARY)
                .font(Font.system(size: 16).weight(.bold))
            
            if tint == nil {
                Divider()
            } else {
                Divider().background(tint)
            }
        }
    }
}
