//
//  MainModelController.swift
//  communitycooking
//
//  Created by FMA2 on 04.12.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

protocol IModelViewController {
    func showErrorMessage(message: String)
    func setRequestedEvents(events: [Event])
    func setParticipatingEvents(events: [Event])
    func setNearEvents(events: [Event])
    func setUser(user: User)
}

class MainModelController {
        
    private let viewController: IModelViewController
    
    init(viewController: IModelViewController) {
        self.viewController = viewController
    }
    
    func setRequestForEvent(user: User, event: Event) {
        var requested = event.requested.filter { temp in temp.documentId != user.documentId }
        requested.append(user)
        
        let temp = Event(
            timestamp: event.timestamp, owner: event.owner, location: event.location, isPublic: event.isPublic, title: event.title, description: event.description, recipe: event.recipe, requested: requested, participating: event.participating.filter { temp in temp.documentId != user.documentId }, documentId: event.documentId!
        )
        
        DatabaseService.setEvent(event: temp) { error in
            if let message = error {
                self.viewController.showErrorMessage(message: message)
            }
        }
    }
    
    func removeRequestForEvent(user: User, event: Event) {
        let temp = Event(
            timestamp: event.timestamp, owner: event.owner, location: event.location, isPublic: event.isPublic, title: event.title, description: event.description, recipe: event.recipe, requested: event.requested.filter { temp in temp.documentId != user.documentId }, participating: event.participating.filter { temp in temp.documentId != user.documentId }, documentId: event.documentId!
        )
        
        DatabaseService.setEvent(event: temp) { error in
            if let message = error {
                self.viewController.showErrorMessage(message: message)
            }
        }
    }
    
    func downloadData() {
        DatabaseService.getMyself {
            result, error in
            if let user = result {
                self.viewController.setUser(user: user)
                DatabaseService.getEventsRequested(user: user) {
                    events, error in
                    if let list = events {
                        self.viewController.setRequestedEvents(events: list)
                    }

                    if let message = error {
                        self.viewController.showErrorMessage(message: message)
                    }
                }

                DatabaseService.getEventsParticipating(user: user) {
                    events, error in
                    if let list = events {
                        self.viewController.setParticipatingEvents(events: list)
                    }

                    if let message = error {
                        self.viewController.showErrorMessage(message: message)
                    }
                }
            }

            if let message = error {
                self.viewController.showErrorMessage(message: message)
            }
        }
    }

    func downloadLocationBasedData(user: User, location: Location) {
        DatabaseService.getEventsByRadius(user: user, userLocation: location) {
            events, error in
            if let list = events {
                self.viewController.setNearEvents(events: list)
            }

            if let message = error {
                self.viewController.showErrorMessage(message: message)
            }
        }
    }
}
