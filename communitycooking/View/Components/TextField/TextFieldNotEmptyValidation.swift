//
//  TextFieldForenameValidation.swift
//  communitycooking
//
//  Created by FMA2 on 01.01.22.
//  Copyright © 2022 THM. All rights reserved.
//

import SwiftUI

struct TextFieldNotEmptyValidation: View {
        
    @State var isInteracted = false
    @State var isErrorShowing = true
    
    @Binding var text: String
    var label: String
    var error: String
    
    var body: some View {
        CustomTextField(text: $text, label: label, error: (isInteracted && isErrorShowing) ? error : nil)
            .onChange(of: text, perform: { value in
            isInteracted = true
            isErrorShowing = value.isEmpty
        })
    }
}
