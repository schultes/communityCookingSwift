//
//  FlippedUpsideDown.swift
//  communitycooking
//
//  Created by FMA2 on 03.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation
import SwiftUI

struct FlippedUpsideDown: ViewModifier {
   func body(content: Content) -> some View {
    content
        .rotationEffect(.degrees(180))
      .scaleEffect(x: -1, y: 1, anchor: .center)
   }
}
