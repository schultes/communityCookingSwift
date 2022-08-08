//
//  TextFieldEmailMatcher.swift
//  communitycooking
//
//  Created by FMA2 on 01.01.22.
//  Copyright © 2022 THM. All rights reserved.
//

import SwiftUI

struct TextFieldEmailValidation: View {
    
    @State var isInteracted = false
    @State var isErrorShowing = true
    
    @Binding var text: String
    var label: String
    
    let errorIncorrect = "Emailadresse ist nicht korrekt eingegeben!"
    let errorEmpty = "Keine Emailadresse eingegeben!"
    
    var body: some View {
        CustomTextField(text: $text, label: label, error: (isInteracted && isErrorShowing) ? text.isEmpty ? errorEmpty : errorIncorrect : nil)
            .onChange(of: text, perform: { value in
                let allowedCharacters = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890@.")
                let input = value.filter { allowedCharacters.contains($0) }.lowercased()
                isInteracted = true
                isErrorShowing = !ValidationService.isEmail(email: input)
                self.text = input
            })
    }
}
