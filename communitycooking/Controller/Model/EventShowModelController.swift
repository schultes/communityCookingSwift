//
//  EventShowModelController.swift
//  communitycooking
//
//  Created by FMA2 on 04.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

protocol IEventShowViewController {
    func setData(userId: String, event: Event)
    func exitActivity()
    func showErrorMessage(message: String)
}

class EventShowModelController {
        
    private let viewController: IEventShowViewController
    
    init(viewController: IEventShowViewController) {
        self.viewController = viewController
    }
    
    func downloadData(eventId: String) {
        if let userId = TPFirebaseAuthentication.getUser()?.uid {
            DatabaseService.getEventById(documentId: eventId) { result, error in
                if let event = result {
                    self.viewController.setData(userId: userId, event: event)
                }
                
                if let message = error {
                    self.viewController.exitActivity()
                }
            }
        }
    }
    
    func leaveEvent(event: Event) {
        
        let me = TPFirebaseAuthentication.getUser()
        
        if me != nil {
            DatabaseService.setEvent(
                event: Event(
                    timestamp: event.timestamp,
                    owner: event.owner,
                    location: event.location,
                    isPublic: event.isPublic,
                    title: event.title,
                    description: event.description,
                    recipe: event.recipe,
                    requested: event.requested,
                    participating: event.participating.filter { user in user.documentId != me!.uid },
                    documentId: event.documentId
                )
            ) { error in
                if let message = error {
                    self.viewController.showErrorMessage(message: message)
                } else {
                    self.viewController.exitActivity()
                }
            }
        }
    }
}

