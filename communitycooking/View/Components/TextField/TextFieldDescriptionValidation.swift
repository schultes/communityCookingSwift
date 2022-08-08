//
//  TextFieldDescriptionValidation.swift
//  communitycooking
//
//  Created by FMA2 on 01.01.22.
//  Copyright © 2022 THM. All rights reserved.
//

import SwiftUI

struct TextFieldDescriptionValidation: View {
            
    @State var isInteracted = false
    @State var isErrorShowing = true
    
    @Binding var text: String
    var label: String
    
    let error = "Keine Beschreibung eingegeben!"
    
    var body: some View {
        
        let binding = Binding(
            get: { self.text },
            set: {
                let input = $0.trimmingCharacters(in: .whitespaces)
                isInteracted = true
                isErrorShowing = input.isEmpty
                self.text = input
            }
        )
                
        CustomEditorField(text: binding, label: label, error: (isInteracted && isErrorShowing) ? error : nil)
    }
}
