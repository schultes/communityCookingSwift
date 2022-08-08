//
//  Typography.swift
//  palmengarten
//
//  Created by FMA2 on 17.11.21.
//  Copyright © 2021 Tobias Heymann. All rights reserved.
//

import Foundation
import SwiftUI

class Typorgraphy {
    let h1 = H1ViewModifier()
    let h2 = H2ViewModifier()
    let h3 = H3ViewModifier()
    let body1 = Body1ViewModifier()
    let body2 = Body2ViewModifier()
}

struct H1ViewModifier: ViewModifier {
    let colors = Colors()
    
    func body(content: Self.Content) -> some View {
        content
            .foregroundColor(colors.SECONDARY)
            .font(Font.system(size: 24).weight(.light))
    }
}

struct H2ViewModifier: ViewModifier {
    let colors = Colors()
    
    func body(content: Self.Content) -> some View {
        content
            .foregroundColor(colors.SECONDARY)
            .font(Font.system(size: 16).weight(.bold))
    }
}

struct H3ViewModifier: ViewModifier {
    let colors = Colors()
    
    func body(content: Self.Content) -> some View {
        content
            .foregroundColor(colors.TEXT_PRIMARY)
            .font(Font.system(size: 12).weight(.bold))
    }
}

struct Body1ViewModifier: ViewModifier {
    let colors = Colors()
    
    func body(content: Self.Content) -> some View {
        content
            .foregroundColor(colors.TEXT_PRIMARY)
            .font(Font.system(size: 12))
    }
}

struct Body2ViewModifier: ViewModifier {
    let colors = Colors()
    
    func body(content: Self.Content) -> some View {
        content
            .foregroundColor(colors.TEXT_PRIMARY)
            .font(Font.system(size: 10))
    }
}
