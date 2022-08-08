//
//  EditorFieldNotEmptyValidation.swift
//  communitycooking
//
//  Created by FMA2 on 02.01.22.
//  Copyright © 2022 THM. All rights reserved.
//

import SwiftUI

struct EditorFieldNotEmptyValidation: View {
        
    @State var isInteracted = false
    @State var isErrorShowing = true
    
    @Binding var text: String
    var label: String
    var error: String
    
    var body: some View {
        CustomEditorField(text: $text, label: label, error: (isInteracted && isErrorShowing) ? error : nil)
            .onChange(of: text, perform: { value in
            isInteracted = true
            isErrorShowing = value.isEmpty
        })
    }
}
