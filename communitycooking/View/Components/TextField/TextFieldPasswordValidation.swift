//
//  TextFieldPasswordValidation.swift
//  communitycooking
//
//  Created by FMA2 on 01.01.22.
//  Copyright © 2022 THM. All rights reserved.
//

import SwiftUI

struct TextFieldPasswordValidation: View {
    
    @State var isInteracted = false
    @State var isErrorShowing = true
    
    @Binding var text: String
    var label: String
    
    let errorIncorrect = "Das Passwort muss mindestens 6 Zeichen lang sein!"
    let errorEmpty = "Kein Passwort eingegeben!"
    
    var body: some View {
        CustomPasswordField(text: $text, label: label, error: (isInteracted && isErrorShowing) ? text.isEmpty ? errorEmpty : errorIncorrect : nil)
            .onChange(of: text, perform: { value in
                isInteracted = true
                isErrorShowing = value.isEmpty || value.count < 6
                self.text = value
            })
    }
}
