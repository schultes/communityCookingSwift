//
//  TextFieldAmountValidation.swift
//  communitycooking
//
//  Created by FMA2 on 01.01.22.
//  Copyright © 2022 THM. All rights reserved.
//

import SwiftUI


struct TextFieldNumberGreaterThanZeroIntValidation: View {
                        
    @State var isInteracted = false
    @State var isErrorShowing = true
    
    @Binding var number: Int
    var label: String
    let error: String
    
    var body: some View {
        let binding = Binding(get: { String(self.number) }, set: { self.number = Int($0) ?? 0 } )
        CustomNumberField(number: binding, label: label, error: (isInteracted && isErrorShowing) ? error : nil)
            .onChange(of: number, perform: { value in
                isInteracted = true
                isErrorShowing = !(value > 0)
                self.number = value > 9999 ? 9999 : value
            })
    }
}

struct TextFieldNumberGreaterThanZeroDoubleValidation: View {
                        
    @State var isInteracted = false
    @State var isErrorShowing = true
    
    @Binding var number: Double
    var label: String
    let error: String
    
    var body: some View {
        let binding = Binding(get: { String(self.number) }, set: { self.number = Double($0) ?? 0 } )
        CustomNumberField(number: binding, label: label, error: (isInteracted && isErrorShowing) ? error : nil)
            .onChange(of: number, perform: { value in
                isInteracted = true
                isErrorShowing = !(value > 0)
            })
    }
}
