//
//  EventEditRequestingUserList.swift
//  communitycooking
//
//  Created by FMA2 on 01.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import SwiftUI

struct EventEditRequestingUserList: View {
    
    var viewController: EventEditViewController
    var users: [User]
    
    var body: some View {
        VStack(spacing: 16) {
                            
            SectionHeader(header: "Ausstehende Anfragen")

            VStack(spacing: 16) {
                ForEach(self.users, id: \.self) { user in
                    HStack(alignment: .center, spacing: 16) {
                        Text(user.username)
                            .modifier(CommunityCookingTheme.typography.h3)
                        
                        Spacer().frame(minWidth: 0, maxWidth: .infinity)
                                                                                    
                        Image("baseline_add_black_24pt")
                            .resizable()
                            .foregroundColor(Color.white)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(CommunityCookingTheme.colors.PRIMARY)
                                    .frame(width: 24, height: 24, alignment: .center)
                            )
                            .frame(width: 16, height: 16)
                            .onTapGesture {
                                self.viewController.participating.append(user)
                                self.viewController.requested.removeAll { temp in temp.documentId == user.documentId }
                            }
                                                                                    
                        Image("baseline_remove_black_24pt")
                            .resizable()
                            .foregroundColor(Color.white)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(CommunityCookingTheme.colors.ERROR)
                                    .frame(width: 24, height: 24, alignment: .center)
                            )
                            .frame(width: 16, height: 16)
                            .onTapGesture {
                                self.viewController.requested.removeAll { temp in temp.documentId == user.documentId }
                            }
                    }                    
                }
            }
        }
    }
}
