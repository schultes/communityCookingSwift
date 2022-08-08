//
//  TextFieldUsernameValidation.swift
//  communitycooking
//
//  Created by FMA2 on 01.01.22.
//  Copyright © 2022 THM. All rights reserved.
//

import SwiftUI

struct TextFieldUsernameValidation: View {
        
    @State var isInteracted = false
    @State var isErrorShowing = true
    
    @Binding var text: String
    var label: String
    
    let error = "Kein Benutzername eingegeben!"
    
    var body: some View {
        CustomTextField(text: $text, label: label, error: (isInteracted && isErrorShowing) ? error : nil)
            .onChange(of: text, perform: { value in
                let allowedCharacters = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
                let input = value.filter { allowedCharacters.contains($0) }.lowercased()
                isInteracted = true
                isErrorShowing = input.isEmpty
                self.text = input
            })
    }
}
