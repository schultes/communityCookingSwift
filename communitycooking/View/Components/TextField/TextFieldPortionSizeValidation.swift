//
//  TextFieldPortionSizeValidation.swift
//  communitycooking
//
//  Created by FMA2 on 01.01.22.
//  Copyright © 2022 THM. All rights reserved.
//

import SwiftUI

struct TextFieldPortionSizeValidation: View {
                    
    @State var isInteracted = false
    @State var isErrorShowing = true
    
    @Binding var number: Int
    var label: String
    
    let error = "Die Portionsgröße muss mindestens 1 sein!"
    
    var body: some View {
        
        let binding = Binding(
            get: { String(self.number) },
            set: {
                let input = Int($0) ?? 0
                isInteracted = true
                isErrorShowing = input < 1
                self.number = input
            }
        )
                
        CustomNumberField(number: binding, label: label, error: (isInteracted && isErrorShowing) ? error : nil)
    }
}
